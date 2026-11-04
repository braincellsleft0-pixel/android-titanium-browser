#!/bin/bash
set -e
echo "Applying custom UI features..."

# Feature 1: Add "load .crx" button to chrome://extensions WebUI developer toolbar
sed -i 's|<cr-button id="loadUnpacked"|<cr-button id="loadCrx" on-click="onLoadCrxClick_">load .crx</cr-button>\n    <cr-button id="loadUnpacked"|' chrome/browser/resources/extensions/toolbar.html

cat << 'EOF' >> chrome/browser/resources/extensions/toolbar_crx_hook.js
function triggerCrxPicker() {
  const input = document.createElement('input');
  input.type = 'file';
  input.accept = '.crx,.zip,application/x-chrome-extension,application/zip';
  input.onchange = (e) => {
    const file = e.target.files[0];
    if (file) {
      const url = URL.createObjectURL(file);
      const a = document.createElement('a');
      a.href = url;
      a.download = file.name;
      document.body.appendChild(a);
      a.click();
      setTimeout(() => URL.revokeObjectURL(url), 60000);
    }
  };
  input.click();
}
EOF

sed -i 's|private onLoadUnpackedClick_() {|onLoadCrxClick_() { triggerCrxPicker(); }\n  private onLoadUnpackedClick_() {|' chrome/browser/resources/extensions/toolbar.ts

# Feature 2: Add "Force Tablet Mode" toggle in Settings and hook DeviceFormFactor
sed -i 's|public static boolean isNonMultiDisplayContextOnTablet(Context context) {|&\n        if (org.chromium.base.ContextUtils.getAppSharedPreferences().getBoolean("force_tablet_mode", false)) return true;|' ui/android/java/src/org/chromium/ui/base/DeviceFormFactor.java

sed -i '/<\/PreferenceScreen>/i\    <org.chromium.components.browser_ui.settings.ChromeSwitchPreference\n        android:key="force_tablet_mode"\n        android:title="Force Tablet Mode"\n        android:summary="Open chromium in Tablet Mode"\n        android:defaultValue="false" />' chrome/android/java/res/xml/accessibility_preferences.xml

echo "Custom features applied successfully!"