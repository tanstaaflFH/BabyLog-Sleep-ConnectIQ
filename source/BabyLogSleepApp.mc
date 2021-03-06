using Toybox.Application;
using Toybox.Application.Storage;

class BabyLogSleepApp extends Application.AppBase {

	var mCurrentSleeps;

    function initialize() {
        AppBase.initialize();
        mCurrentSleeps = new Sleeps();
       	//System.println("BabyLogSleepApp.initialize completed.");
    }

    // onStart() is called on application start up
    function onStart(state) {     
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	var initialView = new EntryView(mCurrentSleeps);
        return [ initialView, new EntryDelegate(initialView, mCurrentSleeps) ];
    }

}