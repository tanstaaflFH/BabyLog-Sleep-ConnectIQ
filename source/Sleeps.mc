using Toybox.Application.Storage;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Utils;

class Sleeps {

	var mSleepStartArray = new[10];
	var mSleepEndArray = new[10];
	var mSleepDurationArray = new[10];
	var mAwakeArray = new[10];
	var mIsSleeping = false;

	function initialize() {
		//System.println("New sleep class created");
		loadTimes();
	}

	function toggleSleep(sleepTime) {
	
		//! toggle sleep status
		mIsSleeping =! mIsSleeping;
	

		if (mIsSleeping) {
		
			//! for a new sleep: add a new entry to the time arrays, deleting the oldest for end arrays		
			mSleepStartArray.add(sleepTime);
			mSleepEndArray.add(null);
			//System.println("Added new feed time to class: " + feedTime + " - new array: " + mTimeArray);
			mSleepStartArray = mSleepStartArray.slice(1,null);
			mSleepEndArray = mSleepEndArray.slice(1,null);
			
			//! calculate the new latest awake time before this sleep
			if ( mSleepEndArray[8] != null ) {
				mAwakeArray.add(sleepTime.subtract(mSleepEndArray[8]));
			} else {
				mAwakeArray.add(null);
			}
			mAwakeArray = mAwakeArray.slice(1,null);
			
			//! shift the sleep duration array
			mSleepDurationArray.add(null);
			mSleepDurationArray = mSleepDurationArray.slice(1,null);
			
		} else {
		
			//! to end a sleep: add a new entry to the time array
			mSleepEndArray[9] = sleepTime;
			
			//! calculate the sleep duration
			if ( mSleepStartArray[9] != null ) {
				mSleepDurationArray[9] = sleepTime.subtract(mSleepStartArray[9]);
			}
			
		}
		
		//! Save to local storage
		saveTimes();
		
	}
	
	function getSleepTimes(index) {
		return [
			mSleepStartArray[index],
			mSleepEndArray[index]
			];			
	}
	
	function getSleepDuration(index) {
		return mSleepDurationArray[index];
	}
	
	function getAwakeDuration(index) {
		return mAwakeArray[index];
	}
	
	function getSleepStartString(index) {
		
		var timeString = new[2];
		
		if (index<0) {
			return "--";
		}
				
		if (mSleepStartArray[index] == null) {
			timeString = "--";
		} else {
			var momNowGreg = Gregorian.info(mSleepStartArray[index], Time.FORMAT_SHORT);
			timeString = Lang.format(
			    "$1$:$2$",
			    [
			        momNowGreg.hour.format("%02d"),
			        momNowGreg.min.format("%02d")
			    ]
			);
		}
		
		return timeString;

	}
	
	function getSleepEndString(index) {
		
		var timeString = new[2];
		
		if (index<0) {
			return "--";
		}
				
		if (mSleepEndArray[index] == null) {
			timeString = "--";
		} else {
			var momNowGreg = Gregorian.info(mSleepEndArray[index], Time.FORMAT_SHORT);
			timeString = Lang.format(
			    "$1$:$2$",
			    [
			        momNowGreg.hour.format("%02d"),
			        momNowGreg.min.format("%02d")
			    ]
			);
		}
		
		return timeString;

	}
		
	function getDurationString(index) {
	
		var durationRaw;
		var durationString;

		if (index instanceof Lang.String) {
			if (mSleepStartArray[mSleepStartArray.size()-1] == null) {
				durationRaw = null;
			} else {
				durationRaw = Math.floor(Time.now().subtract(mSleepStartArray[mSleepStartArray.size()-1]).value());
			}
		} else {
			if (index<0) {
				return "--";
			}
			if (mSleepDurationArray[index] == null) {
				durationRaw = null;
			} else {
				durationRaw = mSleepDurationArray[index].value();
			}
		}			
		
		if (durationRaw == null) {
			durationString = "--";
		} else {
			//System.println("Elapsed time in seconds: " + durationRaw);
			var hours = Utils.hours(durationRaw);
			var minutes = Utils.minutes(durationRaw);
			//System.println("Calculated elapsed time: " + hours + ":" + minutes);
			durationString = Lang.format(
				"$1$:$2$",
				[
					hours.format("%02d"),
					minutes.format("%02d")
				]
			);		
		}
	
		return durationString;
			
	}
	
	function getAwakeString(index) {
	
		var durationRaw;
		var durationString;

		if (index instanceof Lang.String) {
			if (mSleepEndArray[mSleepEndArray.size()-1] == null) {
				durationRaw = null;
			} else {
				durationRaw = Math.floor(Time.now().subtract(mSleepEndArray[mSleepEndArray.size()-1]).value());
			}
		} else {
			if (index<0) {
				return "--";
			}
			if (mAwakeArray[index] == null) {
				durationRaw = null;
			} else {
				durationRaw = mAwakeArray[index].value();
			}
		}			
		
		if (durationRaw == null) {
			durationString = "--";
		} else {
			//System.println("Elapsed time in seconds: " + durationRaw);
			var hours = Utils.hours(durationRaw);
			var minutes = Utils.minutes(durationRaw);
			//System.println("Calculated elapsed time: " + hours + ":" + minutes);
			durationString = Lang.format(
				"$1$:$2$",
				[
					hours.format("%02d"),
					minutes.format("%02d")
				]
			);		
		}
	
		return durationString;
			
	}
	
	function isSleeping() {
	
		return mIsSleeping;
	
	}	

	hidden function saveTimes() {
	
		var saveArray = new[10];

		for( var i = 0; i < mSleepStartArray.size(); i++ ) {
			if (mSleepStartArray[i] != null) {
				saveArray[i] = mSleepStartArray[i].value();
			} else {
				saveArray[i] = null;
			}
		}

		Storage.setValue("SleepStartArray", saveArray);

		for( var i = 0; i < mSleepEndArray.size(); i++ ) {
			if (mSleepEndArray[i] != null) {
				saveArray[i] = mSleepEndArray[i].value();
			} else {
				saveArray[i] = null;
			}
		}

		Storage.setValue("SleepEndArray", saveArray);

		for( var i = 0; i < mSleepDurationArray.size(); i++ ) {
			if (mSleepDurationArray[i] != null) {
				saveArray[i] = mSleepDurationArray[i].value();
			} else {
				saveArray[i] = null;
			}
		}

		Storage.setValue("SleepDurationArray", saveArray);	
			
		for( var i = 0; i < mAwakeArray.size(); i++ ) {
			if (mAwakeArray[i] != null) {
				saveArray[i] = mAwakeArray[i].value();
			} else {
				saveArray[i] = null;
			}
		}

		Storage.setValue("AwakeArray", saveArray);	
				
		Storage.setValue("isSleeping", mIsSleeping);
						
	}
	
	hidden function loadTimes() {
		
		if (Storage.getValue("SleepStartArray") == null) {
		
			System.println("No sleep start times saved yet");
		
		} else {
	
			var loadValue = Storage.getValue("SleepStartArray");
				
			for( var i = 0; i < loadValue.size(); i++ ) {
				if (loadValue[i] != null) {
					mSleepStartArray[i] = new Time.Moment(loadValue[i]);
				}
				
			}
			
		}
						
		if (Storage.getValue("SleepEndArray") == null) {
		
			System.println("No sleep end times saved yet");
		
		} else {
		
			var loadValue = Storage.getValue("SleepEndArray");
			
			for( var i = 0; i < loadValue.size(); i++ ) {
				if (loadValue[i] != null) {
					mSleepEndArray[i] = new Time.Moment(loadValue[i]);
				}
			}
			
		}

		if (Storage.getValue("SleepDurationArray") == null) {
		
			System.println("No sleep duration saved yet");
		
		} else {
		
			var loadValue = Storage.getValue("SleepDurationArray");
			
			for( var i = 0; i < loadValue.size(); i++ ) {
				if (loadValue[i] != null) {
					mSleepDurationArray[i] = new Time.Duration(loadValue[i]);
				}
			}
			
		}

		if (Storage.getValue("AwakeArray") == null) {
		
			System.println("No awake duration saved yet");
		
		} else {
		
			var loadValue = Storage.getValue("AwakeArray");
			
			for( var i = 0; i < loadValue.size(); i++ ) {
				if (loadValue[i] != null) {
					mAwakeArray[i] = new Time.Duration(loadValue[i]);
				}
			}
			
		} 
		
		if (Storage.getValue("isSleeping") == null) {
		
			System.println("No sleep status saved yet");
		
		} else {
		
			var loadValue = Storage.getValue("isSleeping");
			
			mIsSleeping = loadValue;
			
		}
		
	}
				
}