import QtQuick 2.0
import MuseScore 3.0
import QtQuick.Dialogs 1.2
/*import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.3*/

MuseScore {
      menuPath: "Plugins.Score Duration"
      description: qsTr("Outputs a score's total runtime in hours, minutes, and seconds.")
      version: "1.0"
      requiresScore: true
      
      onRun: {
      var score = curScore;
      var dur = score.duration;
      //console.log("configured! now calculating...")
      
      //time calculation for scores < 3600s
      var dursec = dur % 60
      var durmin = (dur - dursec)/60
      
      //time calculation for scores >= 3600s
      if (durmin >= 60) {
            var durmin2 =  durmin % 60
            var durh = (durmin-durmin2)/60
            //sends results to user window and activates it
            console.log ("Calculated score duration: " + durh + " h, " + durmin2 + " min, " + dursec + " s. (" + dur + " s).")
            durationDialog.text = ("Your score '" + score.title + "' is " + durh + " hours, " + durmin2 + " minutes, and " + dursec + " seconds long (" + dur + " seconds).")
            durationDialog.visible = true;
            return;
            }
      //formatting for scores > 60s 
      if (durmin == 0) {
            console.log ("Calculated score duration: " + dursec + "s")    
            durationDialog.text = ("Your score '" + score.title + "' is " + dursec + " seconds long.")
            durationDialog.visible = true;
            return;
            }
      //formatting for 60s =< scores < 3600s
      console.log ("Calculated score duration: " + durmin + " min, " + dursec + " s. (" + dur + " s).")
      durationDialog.text = ("Your score '" + score.title + "' is " + durmin + " minutes and " + dursec + " seconds long (" + dur + " seconds).")
      durationDialog.visible = true;
      }
      
MessageDialog {
//window shown to end user
	id: durationDialog
	visible: false; //is changed once calculation has finished
	title: qsTr("Score Duration");
	text: durationDialog.text
	standardButtons: StandardButton.Ok
	onAccepted: {
	     durationDialog.close();
	     }
	}
}
