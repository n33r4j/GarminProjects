import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class TimTamMeter_v1App extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new TimTamMeter_v1View() ] as Array<Views or InputDelegates>;
    }

(:glance) // Use this to indicate which modules/classes are necessary when running in Glance mode.(to limit memory usage)
    function getGlanceView() {
        return [ new TimeTamMeterGlanceView() ];
    }

}

function getApp() as TimTamMeter_v1App {
    return Application.getApp() as TimTamMeter_v1App;
}