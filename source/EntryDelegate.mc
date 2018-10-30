using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;

class EntryDelegate extends WatchUi.BehaviorDelegate {

	var mCurrentSleeps;
	var mParentView;

    function initialize(view, refFeeds) {
        
        //! Initialize extended class
        BehaviorDelegate.initialize();
        
        //! Initialize module variables
        mCurrentSleeps = refFeeds;
        mParentView = view;
        
    }

	function onToggleSleep() {
		
		//!	get current time and update feed class
		mCurrentSleeps.toggleSleep(Time.now());
		//System.println("New feed list: " + mCurrentSleeps.getFeeds());
		
		//! update labels
		mParentView.updateLabels();
			
	}
	
    function onNextPage() {
        return pushMenu(WatchUi.SLIDE_IMMEDIATE);
    }

    function pushMenu(slideDir) {
        var view = new LogView(mCurrentSleeps);
        var delegate = new LogDelegate(view);
        WatchUi.pushView(view, delegate, slideDir);
        return true;
    }
	 
}
