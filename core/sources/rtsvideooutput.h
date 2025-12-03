#ifndef RTSVIDEOOUTPUT_H
#define RTSVIDEOOUTPUT_H

#include <QQuickItem>
#include <QImage>
#include <QSGTexture>
#include <QSGImageNode>
#include <QMutex>
#include <QFuture>
#include <QtConcurrent>
#include <opencv2/opencv.hpp>
#include <QSGSimpleTextureNode>
#include <QQuickWindow>

class RTSVideoOutput : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QString rtsUrl READ rtsUrl WRITE setRtsUrl NOTIFY rtsUrlChanged FINAL)

public:
    explicit RTSVideoOutput(QQuickItem *parent = nullptr);
    ~RTSVideoOutput() override;

    QString rtsUrl() const;
    void setRtsUrl(const QString &newRtsUrl);

signals:
    void rtsUrlChanged();
    void frameReady(const QImage &frame);

public slots:
    void updateFrame(const QImage &newFrame);  // <-- must be a slot

protected:
    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *) override;
    void componentComplete() override;

private:
    void startProcessing();
    void stop();
    void processRtsFrames(const QString &url);

private:
    QImage m_frame;
    QString m_rtsUrl;

    QFuture<void> m_future;
    bool m_running = false;
    QMutex m_mutex;
};

#endif // RTSVIDEOOUTPUT_H
