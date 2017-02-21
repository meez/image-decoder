package meez.media.codec.gif
{

import com.worlize.gif.GIFDecoder;
import com.worlize.gif.GIFFrame;
import com.worlize.gif.events.AsyncDecodeErrorEvent;
import com.worlize.gif.events.GIFDecoderEvent;

import flash.utils.ByteArray;

import meez.media.codec.Frame;

import meez.media.codec.FrameConsumer;
import meez.media.codec.StreamDecoder;

/** GIF Decoder */
public class GIFStreamDecoder extends StreamDecoder
{
    // Instance variables

    /** Data */
    protected var data:ByteArray;

    /** Decoder */
    protected var decoder:GIFDecoder;

    // Public methods

    /** Create new GIFStreamDecoder */
    public function GIFStreamDecoder(out:FrameConsumer)
    {
        super(out);

        this.decoder=new GIFDecoder();
        this.decoder.addEventListener(GIFDecoderEvent.DECODE_COMPLETE, onDecoderComplete);
        this.decoder.addEventListener(AsyncDecodeErrorEvent.ASYNC_DECODE_ERROR, onDecodeError);
    }

    // Events

    /** Decode is complete */
    private function onDecoderComplete(event:GIFDecoderEvent):void
    {
        // Publish all frames
        while (decoder.frames.length>0)
        {
            var gf:GIFFrame=decoder.frames.pop();

            this.out.onFrame(new Frame("image/gif",gf.bitmapData));
        }

        this.out.onComplete();
    }

    /** Decode failed */
    private function onDecodeError(e:AsyncDecodeErrorEvent):void
    {
        this.out.onError(new Error("Decode failed (reason="+e+")"));
    }

    // DataConsumer implementation

    /** Handle data */
    public override function onData(data:ByteArray):void
    {
        this.data=data;
    }

    /** Complete */
    public override function onComplete():void
    {
        this.decoder.decodeBytes(this.data);
    }
}

}