#ifndef CORE_H
#define CORE_H

#include <QObject>
#include <QTimer>
#include <QVariant>
#include <QDebug>
#include <QDir>
#include <QtConcurrent/QtConcurrent>

class Core : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int workload READ getValue WRITE setValue NOTIFY progress)

public:
    explicit Core(QObject *parent = nullptr);

    QString src1 = "G:/Phone Backup";
    QString dst1 = "D:/Desktop/Phone Backup";

    int getValue();
    void setValue(int data);

signals:
    void progress();
    void started();
    void stopped();
    void paused();
    void resumed();

public slots:
    void start();
    void stop();
    void pause();
    void resume();

private:
    int m_progress;
    int m_fileCount;
    int m_filesTransferedCount;
    bool m_stillRunning;
    bool m_quitCommandExecuted;

    void copyPath(QString src, QString dst);
    int  countFilesInDir(QString srcDir);

};

#endif // CORE_H
