package meez.media.codec
{

/** Output Tracker */
public class OutputTracker implements FrameConsumer
{
    // Instance variables

    /** Callbacks */
    private var fnComplete:Function,fnError:Function;

    /** Output Tracker */
    public function OutputTracker(fnComplete:Function,fnError:Function=null)
    {
        this.fnComplete=fnComplete;
        this.fnError=fnError;
    }

    // FrameConsumer implementation

    /** Frame */
    public function onFrame(frame:Frame):void
    {
        trace("DEBUG: onFrame("+frame+")");

        // Consumer is responsible for release the frame
        frame.release();
    }

    /** Complete */
    public function onComplete():void
    {
        this.fnComplete();
    }

    /** Error */
    public function onError(e:Error):void
    {
        trace("ERROR: Decode failed (e="+e+")");

        this.fnError("Decode failed (e="+e+")");
    }
}

}
