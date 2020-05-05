#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QThread>
#include <QQuickStyle>

#include "core.h"

int main(int argc, char *argv[]) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");

    qmlRegisterType<Core>("com.renda.core", 1, 0, "Core");

    QQmlApplicationEngine engine;

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(
                &engine, &QQmlApplicationEngine::objectCreated, &app, [url](
                QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
