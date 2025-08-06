// #pragma once

// #include "QGCCorePlugin.h"
// #include "QGCOptions.h"
// #include "QGCLoggingCategory.h"
// #include "SettingsManager.h"

// class CustomOptions;
// class CustomPlugin;

// Q_DECLARE_LOGGING_CATEGORY(CustomLog)

// class CustomFlyViewOptions : public QGCFlyViewOptions
// {
//     Q_OBJECT
// public:
//     CustomFlyViewOptions(CustomOptions* options, QObject* parent = nullptr);
//     bool showInstrumentPanel(void) const final;
//     bool showMultiVehicleList(void) const final;
// };

// class CustomOptions : public QGCOptions
// {
//     Q_OBJECT
// public:
//     CustomOptions(CustomPlugin* plugin, QObject* parent = nullptr);
//     bool wifiReliableForCalibration(void) const final;
//     bool showFirmwareUpgrade(void) const final;
//     QGCFlyViewOptions* flyViewOptions(void) final;

// private:
//     CustomFlyViewOptions* _flyViewOptions = nullptr;
// };

// class CustomPlugin : public QGCCorePlugin
// {
//     Q_OBJECT

// public:
//     CustomPlugin(QGCApplication* app, QGCToolbox *toolbox);
//     ~CustomPlugin();

//     // Overrides from QGCCorePlugin
//     QVariantList& settingsPages(void) final;
//     QGCOptions* options(void) final;
//     QString brandImageIndoor(void) const final;
//     QString brandImageOutdoor(void) const final;
//     bool overrideSettingsGroupVisibility(QString name) final;
//     bool adjustSettingMetaData(const QString& settingsGroup, FactMetaData& metaData) final;
//     void paletteOverride(QString colorName, QGCPalette::PaletteColorInfo_t& colorInfo) final;
//     QQmlApplicationEngine* createQmlApplicationEngine(QObject* parent) final;

//     // Overrides from QGCTool
//     void setToolbox(QGCToolbox* toolbox);

// private slots:
//     void _advancedChanged(bool advanced);

// private:
//     void _addSettingsEntry(const QString& title, const char* qmlFile, const char* iconFile = nullptr);

// private:
//     CustomOptions* _options = nullptr;
//     QVariantList _customSettingsList;
// };

#pragma once

#include "QGCCorePlugin.h"
#include "QGCOptions.h"
#include "QGCLoggingCategory.h"
#include "SettingsManager.h"
#include "AuthManager.h"

class CustomOptions;
class CustomPlugin;
class CustomSettings;


Q_DECLARE_LOGGING_CATEGORY(CustomLog)

class CustomFlyViewOptions : public QGCFlyViewOptions
{
    Q_OBJECT
public:
    CustomFlyViewOptions(CustomOptions* options, QObject* parent = nullptr);
    bool showInstrumentPanel(void) const final;
    bool showMultiVehicleList(void) const final;
};

class CustomOptions : public QGCOptions
{
    Q_OBJECT
public:
    CustomOptions(CustomPlugin* plugin, QObject* parent = nullptr);
    bool wifiReliableForCalibration(void) const final;
    bool showFirmwareUpgrade(void) const final;
    QGCFlyViewOptions* flyViewOptions(void) final;

private:
    CustomFlyViewOptions* _flyViewOptions = nullptr;
};


class CustomPlugin : public QGCCorePlugin
{
    Q_OBJECT

public:
    CustomPlugin(QGCApplication* app, QGCToolbox *toolbox);
    ~CustomPlugin();

    // Overrides from QGCCorePlugin
    QVariantList& settingsPages(void) final;
    QGCOptions* options(void) final;
    QString brandImageIndoor(void) const final;
    QString brandImageOutdoor(void) const final;
    bool overrideSettingsGroupVisibility(QString name) final;
    bool adjustSettingMetaData(const QString& settingsGroup, FactMetaData& metaData) final;
    void paletteOverride(QString colorName, QGCPalette::PaletteColorInfo_t& colorInfo) final;
    QQmlApplicationEngine* createQmlApplicationEngine(QObject* parent) final;
    

    // Overrides from QGCTool
    void setToolbox(QGCToolbox* toolbox);

private slots:
    void _advancedChanged(bool advanced);

private:
    void _addSettingsEntry(const QString& title, const char* qmlFile, const char* iconFile = nullptr);

private:
    CustomOptions* _options = nullptr;
    QVariantList _customSettingsList;
    AuthManager* m_authManager;

public:
    // Add this line to your CustomPlugin class
    QList<int> firstRunPromptStdIds(void) override;
};
