/**
 * Created by NinhNQ on 8/26/2014.
 */
package game.data.vo.campaign_sweep {
import game.data.xml.MissionXML;
import game.ui.dialog.dialogs.SweepCampaignDialog;

public class SweepInfo {

    public var missionXML:MissionXML;
    public var state:int = SweepCampaignDialog.INIT;

    public function SweepInfo() {
    }
}
}
