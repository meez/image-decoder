package meez.media.codec.jpg 
{

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.utils.ByteArray;

import meez.media.codec.Frame;
import meez.media.codec.FrameConsumer;
import meez.media.codec.StreamDecoder;

public class JPGStreamDecoder extends StreamDecoder
{
    // Instance vars
    
    /** Data */
    protected var data:ByteArray;
    
    /** JPG Decoder */
    protected var decoder:JPGDecoder;

    // Public methods
    
    /** Create a new JPGStreamDecoder */
    public function JPGStreamDecoder(out:FrameConsumer) 
    {
        super(out);
        
        this.decoder=new JPGDecoder();
        this.decoder.addEventListener(Event.COMPLETE, onDecodeComplete);
        this.decoder.addEventListener(ErrorEvent.ERROR, onDecodeError);
    }
        
    // DataConsumer Implementation
    
    /** Handle data */
    public override function onData(data:ByteArray):void
    {
        this.data=data;
    }

    /** Complete */
    public override function onComplete():void
    {
        this.decoder.decode(this.data);
    }
    
    // Events
    
    /** On Decoder Complete */
    protected function onDecodeComplete(e:Event):void
    {
        // Publish all frames (s/b only 1)
        while (this.decoder.frames.length>0)
        {
            var f:*=this.decoder.frames.pop();
            this.out.onFrame(new Frame("image/jpeg",f.bitmapData));
        }
        this.out.onComplete();
    }
    
    /** On Decoder Error */
    protected function onDecodeError(e:ErrorEvent):void
    {
        this.out.onError(new Error(e.text, e.errorID));
    }
    
}

}