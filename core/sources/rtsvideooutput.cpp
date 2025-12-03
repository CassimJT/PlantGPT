#include "rtsvideooutput.h"
#include <QThread>
#include <QElapsedTimer>
#include <QDebug>
#include <QMutexLocker>

RTSVideoOutput::RTSVideoOutput(QQuickItem *parent)
    : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);

    connect(this, &RTSVideoOutput::frameReady, this, [this](const QImage &img){
        if (QThread::currentThread() != thread()) {
            QMetaObject::invokeMethod(this, "updateFrame", Qt::QueuedConnection, Q_ARG(QImage, img));
        } else {
            updateFrame(img);
        }
    });

    connect(this, &RTSVideoOutput::rtsUrlChanged, this, &RTSVideoOutput::startProcessing);
}

RTSVideoOutput::~RTSVideoOutput() { stop(); }

void RTSVideoOutput::componentComplete()
{
    QQuickItem::componentComplete();
    if (!m_rtsUrl.isEmpty())
        startProcessing();
}

QString RTSVideoOutput::rtsUrl() const { return m_rtsUrl; }

void RTSVideoOutput::setRtsUrl(const QString &newRtsUrl)
{
    if (m_rtsUrl == newRtsUrl) return;
    stop();
    m_rtsUrl = newRtsUrl;
    emit rtsUrlChanged();
}

void RTSVideoOutput::stop()
{
    m_running = false;
    if (m_future.isRunning())
        m_future.waitForFinished();
}

void RTSVideoOutput::startProcessing()
{
    if (m_rtsUrl.isEmpty()) return;
    m_running = true;
    m_future = QtConcurrent::run([this, url = m_rtsUrl]() {
        processRtsFrames(url);
    });
}

void RTSVideoOutput::processRtsFrames(const QString &url)
{
    // THIS IS THE ONLY FIX YOU NEED
    cv::VideoCapture cap(url.toStdString(), cv::CAP_FFMPEG);


    // Optional: extra parameters for MJPEG-over-RTSP (helps a lot)
    cap.set(cv::CAP_PROP_BUFFERSIZE, 1);
    cap.set(cv::CAP_PROP_READ_TIMEOUT_MSEC, 5000);

    if (!cap.isOpened()) {
        qWarning() << "Could not open RTSP stream (even with FFMPEG):" << url;
        return;
    }

    qDebug() << "RTSP stream opened SUCCESSFULLY with CAP_FFMPEG!";

    cv::Mat frame, resized;
    QElapsedTimer timer;
    const int targetFPS = 15;
    const int frameDelayMs = 1000 / targetFPS;
    timer.start();

    while (m_running) {
        if (!cap.read(frame)) {  // ← use read() instead of >>
            qWarning() << "cap.read() failed – reconnecting...";
            cap.open(url.toStdString(), cv::CAP_FFMPEG);  // auto-reconnect
            QThread::msleep(500);
            continue;
        }

        if (frame.empty()) {
            QThread::msleep(10);
            continue;
        }

        // YOUR FULL OPENVC PIPELINE HERE (resize, detect plants, draw, etc.)
        cv::resize(frame, resized, cv::Size(640, 480));
        cv::cvtColor(resized, resized, cv::COLOR_BGR2RGB);

        // Example processing (remove or replace with yours)
        cv::putText(resized, "PlantGPT Running", cv::Point(10,30),
                    cv::FONT_HERSHEY_SIMPLEX, 1.0, cv::Scalar(0,255,0), 2);

        QImage img(resized.data, resized.cols, resized.rows,
                   static_cast<int>(resized.step), QImage::Format_RGB888);

        emit frameReady(img.copy());

        // FPS limiter
        int elapsed = timer.elapsed();
        int delay = frameDelayMs - elapsed;
        if (delay > 0) QThread::msleep(delay);
        timer.restart();
    }

    cap.release();
}

void RTSVideoOutput::updateFrame(const QImage &newFrame)
{
    {
        QMutexLocker locker(&m_mutex);
        m_frame = newFrame;
    }

    qDebug() << "Frame received in GUI thread:" << newFrame.size();  // You MUST see this!

    update();  // Trigger repaint
}

QSGNode *RTSVideoOutput::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *)
{
    QSGSimpleTextureNode *node = static_cast<QSGSimpleTextureNode *>(oldNode);

    QImage frame;
    {
        QMutexLocker lock(&m_mutex);
        frame = m_frame;
    }

    if (frame.isNull()) {
        delete node;
        return nullptr;
    }

    if (!node) {
        node = new QSGSimpleTextureNode();
        node->setOwnsTexture(true);
    }

    // Delete old texture
    if (node->texture()) {
        delete node->texture();
        node->setTexture(nullptr);
    }

    // Qt 6.10 Android — correct flags with cast
    QSGTexture *texture = window()->createTextureFromImage(
        frame,
        static_cast<QQuickWindow::CreateTextureOptions>(
            QQuickWindow::CreateTextureOption::TextureIsOpaque |
            QQuickWindow::CreateTextureOption::TextureCanUseAtlas
            )
        );

    if (texture) {
        node->setTexture(texture);
        node->setFiltering(QSGTexture::Linear);
        node->setRect(boundingRect());
        node->markDirty(QSGNode::DirtyMaterial | QSGNode::DirtyGeometry);
    } else {
        qWarning() << "createTextureFromImage() returned nullptr! Frame size:" << frame.size();
    }

    return node;
}
