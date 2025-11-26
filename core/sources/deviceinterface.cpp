#include "deviceinterface.h"

DeviceInterface::DeviceInterface(QObject *parent)
    : QObject{parent}
{
    //Constractor
    mqttClient = new QMqttClient(this);
    establishConnection();
    manager = new QNetworkAccessManager(this);

    //connection
    connect(mqttClient,&QMqttClient::connected, this,&DeviceInterface::mqttConnected);
    connect(mqttClient,&QMqttClient::disconnected, this,&DeviceInterface::mqttDisconnected);
    connect(mqttClient,&QMqttClient::errorChanged, this,&DeviceInterface::errorOccured);
    connect(mqttClient,&QMqttClient::messageReceived, this,&DeviceInterface::onMqttMessageReceived);
    connect(mqttClient, &QMqttClient::errorChanged,this, &DeviceInterface::onMqttError);
    connect(mqttClient,&QMqttClient::stateChanged, this, &DeviceInterface::onMqttStateChanged);
}


DeviceInterface::~DeviceInterface()
{
    //Destractor
    delete manager;
    delete mqttClient;

}
/**
 * @brief DeviceInterface::temperature
 * @return the temperature from DHT11
 */
double DeviceInterface::temperature() const
{
    return m_temperature;
}
/**
 * @brief DeviceInterface::setTemperature
 * @param newTemperature
 * set the value of temperature from DHT11
 */
void DeviceInterface::setTemperature(double newTemperature)
{
    if (qFuzzyCompare(m_temperature, newTemperature))
        return;
    m_temperature = newTemperature;
    emit temperatureChanged();
}
/**
 * @brief DeviceInterface::humidty
 * @return the humidity from the DHT11
 */
double DeviceInterface::humidity() const
{
    return m_humidity;
}
/**
 * @brief DeviceInterface::setHumidty
 * @param newHumidty
 * set the value of the humidity from the DHT11
 */
void DeviceInterface::setHumidity(double newHumidity)
{
    if (qFuzzyCompare(m_humidity, newHumidity))
        return;
    m_humidity = newHumidity;
    emit humidityChanged();
}
/**
 * @brief DeviceInterface::replayReadyRead
 * when the replay body is ready to read
 */
void DeviceInterface::replayReadyRead()
{
    if(!replay){
        qDebug()<<"Replay Canceled";
        return;
    }
    if(replay->error() == QNetworkReply::NoError){
        auto data = replay->readAll();
        if(!data.isEmpty()) {
            QJsonDocument jsondoc = QJsonDocument::fromJson(data);
            if(jsondoc.isArray()) {
                QJsonArray arr = jsondoc.array();
                if(!arr.isEmpty()) {
                    QJsonObject lastobj = arr.at(0).toObject();
                    double latestTemp = lastobj["temp"].toDouble();
                    setTemperature(latestTemp);
                }
            }

        }else{
            qDebug()<<"No temperature readding";
        }
    }else {
        qDebug()<<"Error:" <<replay->errorString();
    }
    replay->deleteLater();
}
/**
 * @brief DeviceInterface::errorOccurred
 * @param code
 * a solot to involk when an error occure
 */
void DeviceInterface::errorOccurred(QNetworkReply::NetworkError code)
{
    QString m_error = replay->errorString();
    emit error(m_error);
}
/**
 * @brief DeviceInterface::fetchTemp
 * fetch temperaure reading from the api
 */
void DeviceInterface::fetchTemp()
{
    replay = manager->get(QNetworkRequest(QUrl("http://192.168.8.116:3000/api/iot/temp")));
    connect(replay,&QNetworkReply::readyRead,this,&DeviceInterface::replayReadyRead);
    connect(replay,&QNetworkReply::errorOccurred, this, &DeviceInterface::errorOccurred);
}
/**
 * @brief DeviceInterface::mqttConnected
 * connect to mqtt blocker
 */
void DeviceInterface::mqttConnected()
{
    qDebug() << "Connected from MQTT broker.";
    setConnected(true);
    auto subscription = mqttClient->subscribe(QMqttTopicFilter("iot/temp"),0);
    if(!subscription) {
        qDebug() << "Faild to subscribe";
    }
}
/**
 * @brief DeviceInterface::mqttDisconnected
 * disconnect form the Mqtt blocker
 */
void DeviceInterface::mqttDisconnected()
{
    setConnected(false);
    qDebug() << "Disconnected from MQTT broker.";
}
/**
 * @brief DeviceInterface::onMqttMessageReceived
 * @param message
 * @param topic
 * a slot to be involked when the ESP32 published the readings
 */
void DeviceInterface::onMqttMessageReceived(const QByteArray &message, const QMqttTopicName &topic)
{
    qDebug() << "Received message on topic" << topic.name() << ":" << message;
    // when topic is "iot/temp"
    if(topic.name() == "iot/temp") {

        QJsonDocument jsondoc = QJsonDocument::fromJson(message);
        if(!jsondoc.isNull()) {
            if (jsondoc.isObject()) {
                QJsonObject obj = jsondoc.object();
                if (obj.contains("temp") && obj["temp"].isDouble() && obj.contains("hum") && obj["hum"].isDouble() ) {
                    double latestTemp = obj["temp"].toDouble();
                    double latestHum = obj["hum"].toDouble();
                    setTemperature(latestTemp);
                    setHumidity(latestHum);
                }
            }
        }else {
            qWarning() << "Invalid JSON received:" << message;
            return;
        }
    }
    //more topic will follow here
}
/**
 * @brief DeviceInterface::errorOccured
 * @param error
 * a slot to be involked when an error occured from Qmtt
 */
void DeviceInterface::errorOccured(QMqttClient::ClientError error)
{
    qDebug() << "error:" << error;
}
/**
 * @brief DeviceInterface::publishFanState
 * @param state
 * tun fun on and off
 */
void DeviceInterface::publishFanState(bool state)
{
    QByteArray msg = state ? "on": "off";
    QMqttTopicName topic("iot/fan/state");
    if(mqttClient->state() == QMqttClient::Connected) {
        mqttClient->publish(topic,msg,0,false);
    }else {
        qDebug()<<" Server not connected ";
    }

}
/**
 * @brief DeviceInterface::publishREDState
 * @param state
 * turn an led on and off
 */
void DeviceInterface::publishLEDState(bool state)
{
    QByteArray msg = state ? "on": "off";
    QMqttTopicName topic("iot/led/state");
    if(mqttClient->state() == QMqttClient::Connected) {
        mqttClient->publish(topic,msg,0,false);
    }else {
        qDebug()<<" Server not connected ";
    }

}
/**
 * @brief DeviceInterface::onMqttError
 * @param error
 * emit a signal when an error occure
 */
void DeviceInterface::onMqttError(QMqttClient::ClientError error)
{
    if(error != QMqttClient::NoError) {
        emit mqttError(error);
    }
}
/**
 * @brief DeviceInterface::onMqttStateChanged
 * @param state
 * action when state changed
 */
void DeviceInterface::onMqttStateChanged(QMqttClient::ClientState state)
{
    switch (state) {
    case QMqttClient::Disconnected:
        emit connectionFailed();
        setConnected(false);
        break;
    case QMqttClient::Connected:
        emit connectionSuccessful();
        break;
    case QMqttClient::Connecting:
        qDebug() << "Connecting to MQTT broker...";
        break;
    }
}
/**
 * @brief DeviceInterface::connected
 * @return true if onnected else false
 */
bool DeviceInterface::connected() const
{
    return m_connected;
}
/**
 * @brief DeviceInterface::setConnected
 * @param newConnected
 * set the connected state
 */
void DeviceInterface::setConnected(bool newConnected)
{
    if (m_connected == newConnected)
        return;
    m_connected = newConnected;
    emit connectionEstablished(newConnected);
}

void DeviceInterface::establishConnection()
{
    if (!mqttClient)
        return;
    mqttClient->setHostname("192.168.8.130");
    mqttClient->setPort(1883);
    mqttClient->connectToHost();
}
