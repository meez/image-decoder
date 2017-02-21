package meez.media.codec
{

import flash.utils.ByteArray;

/** Base-class for Codecs */
public class StreamDecoder implements DataConsumer
{
    // Instance variables

    /** Output */
    public var out:FrameConsumer;

    // Public methods

    /** Create new StreamDecoder */
    public function StreamDecoder(out:FrameConsumer)
    {
        this.out=out;
    }

    // DataConsumer implementation

    /** Handle data */
    public function onData(data:ByteArray):void
    {
    }

    /** Complete */
    public function onComplete():void
    {
        // TBD: Any partially processed data should be handled, or trigger error

        this.out.onComplete();
    }

    /** Fail */
    public function onError(e:Error):void
    {
        this.out.onError(new Error("Stream terminated",e));
    }
}

}