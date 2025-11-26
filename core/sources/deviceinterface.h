#ifndef DEVICEINTERFACE_H
#define DEVICEINTERFACE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrl>
#include <QTimer>
#include <QMqttClient>

class DeviceInterface : public QObject
{

    Q_PROPERTY(double temperature READ temperature WRITE setTemperature NOTIFY temperatureChanged FINAL)

    Q_PROPERTY(double humidity READ humidity WRITE setHumidity NOTIFY humidityChanged FINAL)

    Q_PROPERTY(bool connected READ connected NOTIFY connectionEstablished)

    Q_OBJECT
public:
    explicit DeviceInterface(QObject *parent = nullptr);
    ~DeviceInterface();
    double temperature() const;
    void setTemperature(double newTemperature);

    double humidity() const;
    void setHumidity(double newHumidty);

    bool connected() const;
    void setConnected(bool newConnected);

    Q_INVOKABLE void establishConnection();

public slots:
    void replayReadyRead();

    void errorOccurred(QNetworkReply::NetworkError code);

    void fetchTemp();

    void mqttConnected();

    void mqttDisconnected();

    void onMqttMessageReceived(const QByteArray &message, const QMqttTopicName &topic);

    void errorOccured(QMqttClient::ClientError error);

    void publishFanState(bool state);

    void publishLEDState(bool state);

    void onMqttError(QMqttClient::ClientError error);

    void onMqttStateChanged(QMqttClient::ClientState state);


signals:

    void temperatureChanged();

    void humidityChanged();

    void connectionEstablished(bool state);

    void error(QString &errorString);

    void mqttError(QMqttClient::ClientError error);

    void connectionSuccessful();

    void connectionFailed();


private:
    QNetworkAccessManager *manager = nullptr;

    QNetworkReply *replay = nullptr;

    QTimer *m_timer;

    double m_temperature;

    double m_humidity;

    QMqttClient *mqttClient = nullptr;
    bool m_connected = false;


};

#endif // DEVICEINTERFACE_H
