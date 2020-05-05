#include "core.h"

Core::Core(QObject *parent) : QObject(parent) {
    m_progress = 0;
    m_fileCount = 0;
    m_filesTransferedCount = 0;
    m_stillRunning = true;
}

int  Core::countFilesInDir(QString srcDir) {
    static int count = 0;
    qDebug() << srcDir;

    QDir dir(srcDir);
    if (!dir.exists()) {
        qWarning() << "SOURCE DOES NOT EXIST: " << srcDir;
        return 0;
    }

    foreach (QString d, dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot)) {
        countFilesInDir(srcDir+ QDir::separator() + d);
    }

    foreach (QString f, dir.entryList(QDir::Files)) {
        count ++;
    }

    return count;
}

void Core::copyPath(QString src, QString dst) {
    QDir dir(src);

    foreach (QString d, dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot)) {  // | QDir::NoSymLinks
        QString dst_path = dst + QDir::separator() + d;
        dir.mkpath(dst_path);
        copyPath(src + QDir::separator() + d, dst_path);
    }

    foreach (QString f, dir.entryList(QDir::Files)) {
        while(!m_stillRunning) {
            QThread::msleep(500);
        }

        bool errCheck = QFile::copy(src + QDir::separator() + f, dst + QDir::separator() + f);

        if (!errCheck) {
            qWarning() << "UNABLE TO COPY FILE: " << src + QDir::separator() + f;
        } else {
            m_filesTransferedCount ++;
            float currentProgress = ((float)m_filesTransferedCount / m_fileCount) * 100;
            setValue((int)currentProgress);
        }
    }
}

int Core::getValue() {
    return m_progress;
}

void Core::setValue(int data) {
    m_progress = data;
    emit progress();
}

void Core::start() {
    setValue(0);
    emit started();

    m_fileCount = countFilesInDir(src1);
    qDebug() << m_fileCount;

    if(m_fileCount) {
        QFuture<void> f = QtConcurrent::run(this, &Core::copyPath, src1, dst1);
    }
}

void Core::stop() {
    emit stopped();
}

void Core::pause() {
    m_stillRunning = false;
    emit paused();
}

void Core::resume() {
    m_stillRunning = true;
    emit resumed();
}
