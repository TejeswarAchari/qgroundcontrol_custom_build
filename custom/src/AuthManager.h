// #pragma once

// #include <QObject>
// #include <QString>

// class AuthManager : public QObject
// {
//     Q_OBJECT
//     Q_PROPERTY(bool showSplash READ showSplash WRITE setShowSplash NOTIFY showSplashChanged)
//     Q_PROPERTY(bool showLogin READ showLogin WRITE setShowLogin NOTIFY showLoginChanged)
//     Q_PROPERTY(bool isAuthenticated READ isAuthenticated NOTIFY authenticationChanged)

// public:
//     static AuthManager& instance();

//     bool showSplash() const { return m_showSplash; }
//     void setShowSplash(bool show);

//     bool showLogin() const { return m_showLogin; }
//     void setShowLogin(bool show);

//     bool isAuthenticated() const { return m_authenticated; }

//     Q_INVOKABLE void startAuthSequence();
//     Q_INVOKABLE bool authenticate(const QString& username, const QString& password);

// signals:
//     void showSplashChanged();
//     void showLoginChanged();
//     void authenticationChanged();

// private:
//     AuthManager(QObject* parent = nullptr);

//     bool m_showSplash = true;
//     bool m_showLogin = false;
//     bool m_authenticated = false;

//     static const QString VALID_USERNAME;
//     static const QString VALID_PASSWORD;
// };

#pragma once

#include <QObject>
#include <QString>

enum class UserRole {
    None,
    Operator,
    Engineer
};

class AuthManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool showSplash READ showSplash WRITE setShowSplash NOTIFY showSplashChanged)
    Q_PROPERTY(bool showLogin READ showLogin WRITE setShowLogin NOTIFY showLoginChanged)
    Q_PROPERTY(bool isAuthenticated READ isAuthenticated NOTIFY authenticationChanged)
    Q_PROPERTY(int currentUserRole READ currentUserRole NOTIFY userRoleChanged)

public:
    static AuthManager& instance();

    bool showSplash() const { return m_showSplash; }
    void setShowSplash(bool show);

    bool showLogin() const { return m_showLogin; }
    void setShowLogin(bool show);

    bool isAuthenticated() const { return m_authenticated; }
    int currentUserRole() const { return static_cast<int>(m_currentRole); }
    
    Q_INVOKABLE void startAuthSequence();
    Q_INVOKABLE bool authenticate(const QString& username, const QString& password);
    Q_INVOKABLE bool hasEngineerAccess() const;
    Q_INVOKABLE QString getCurrentUsername() const { return m_currentUsername; }
    Q_INVOKABLE void logout();


signals:
    void showSplashChanged();
    void showLoginChanged();
    void authenticationChanged();
    void userRoleChanged();
    void clearLoginFields();

private:
    AuthManager(QObject* parent = nullptr);

    bool m_showSplash = true;
    bool m_showLogin = false;
    bool m_authenticated = false;
    UserRole m_currentRole = UserRole::None;
    QString m_currentUsername;

    // User credentials with roles
    struct UserCredentials {
        QString username;
        QString password;
        UserRole role;
    };
    
    static const QList<UserCredentials> VALID_USERS;
};
