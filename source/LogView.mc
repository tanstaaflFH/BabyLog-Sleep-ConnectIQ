using Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Utils;

class LogView extends WatchUi.View {

	var mCurrentSleeps;

    function initialize(currentSleeps) {
        View.initialize();
        mCurrentSleeps = currentSleeps;
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.LogLayout(dc));      
        updateLogLabels(9);
        System.println("Layout loaded for FBSView");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	
    }

    // Update the view
    function onUpdate(dc) {
    
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
       
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

	function updateLogLabels(startingPoint) {
		
		for (var i=0;i<4;i++) {
		
			var currentTimeLabel = View.findDrawableById("lblSleepLogTime"+i);
			var currentSleepDurationLabel = View.findDrawableById("lblSleepLogSlept"+i);
			var currentAwakeDurationLabel = View.findDrawableById("lblSleepLogAwake"+i);
						
			var labelTimeString = Lang.format(
				"$1$. $2$ - $3$",
				[	
					10-startingPoint+i,
					mCurrentSleeps.getSleepStartString(startingPoint-i),
					mCurrentSleeps.getSleepEndString(startingPoint-i)
				]
			);
			var labelSleepDurationString = Lang.format(
				"Slept: $1$",
				[
					mCurrentSleeps.getDurationString(startingPoint-i)
				]
			);
			var labelAwakeDurationString = Lang.format(
				"Awake: $1$",
				[
					mCurrentSleeps.getAwakeString(startingPoint-i)
				]
			);							
			//System.println("Date Log label: "+labelString);
			if ((10-startingPoint+i) == 11) {
				labelTimeString = "";
				labelSleepDurationString = "";
				labelAwakeDurationString = "";
			}
            currentTimeLabel.setText(labelTimeString);
            currentSleepDurationLabel.setText(labelSleepDurationString);
            currentAwakeDurationLabel.setText(labelAwakeDurationString);
            
		}
		
		WatchUi.requestUpdate();
	
	}

}
