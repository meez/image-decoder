package meez.media.codec
{

/** Consumer interface for Frame */
public interface FrameConsumer
{
    /** Handle next frame */
    function onFrame(frame:Frame):void;

    /** Sequence complete */
    function onComplete():void;

    /** Sequence failed
     *
     * @param e     reason
     *
     */
    function onError(e:Error):void;
}

}
