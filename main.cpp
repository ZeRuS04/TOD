#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "settings.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QApplication::setOrganizationName("MySoft");
    QApplication::setOrganizationDomain("mysoft.com");
    QApplication::setApplicationName("TOD");
    Settings* settings = new Settings();
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("settings", settings);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
