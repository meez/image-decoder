package meez.media.codec.jpg 
{

import flash.display.BitmapData;
import flash.utils.ByteArray;

import meez.media.codec.Frame;
import meez.media.codec.FrameConsumer;
import meez.media.codec.StreamDecoder;

public class JPGStreamDecoder extends StreamDecoder
{
    // Instance vars
    
    /** Data */
    protected var buffer:ByteArray;

    // Public methods
    
    /** Create a new JPGStreamDecoder */
    public function JPGStreamDecoder(out:FrameConsumer) 
    {
        super(out);
        this.buffer=new ByteArray();
    }
    
    // Public Static Methods
    
    /** Matches Header */
    public static function matchesHeader(bytes:ByteArray):Boolean
    {
        try
        {
            bytes.position=0;
            if (bytes.bytesAvailable<2)
                return false;
            
            var b1:int=bytes.readByte() & 0xFF;
            var b2:int=bytes.readByte() & 0xFF;
            if (b1==0xFF && b2==0xD8)
                return true;
        }
        catch (e:Error)
        {
            trace("[JPGDecoder] matchesHeader error", e);
            return false;
        }
        return false;
    }
        
    // DataConsumer Implementation
    
    /** Handle data */
    public override function onData(data:ByteArray):void
    {
        this.buffer.writeBytes(data, this.buffer.position, data.bytesAvailable);
    }

    /** Complete */
    public override function onComplete():void
    {
        // JPG Decoder requires entire file bytearray to get at the single image frame
        var jf:JPGFrame=new JPGFrame(this.buffer, {onComplete:onParseComplete, onError:onParseError});
        jf.parse();
    }
    
    // Events
    
    /** On Decoder Complete */
    protected function onParseComplete(bmp:BitmapData):void
    {
        this.out.onFrame(new Frame("image/jpeg",bmp));
        this.out.onComplete();
    }
    
    /** On Decoder Error */
    protected function onParseError(e:Error):void
    {
        this.out.onError(e);
    }
    
}
}

import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.utils.ByteArray;

/** Image Frame Object */
class JPGFrame
{
    /** Callback Object */
    private var callback:Object;
    
    /** Raw Source */
    private var raw:ByteArray;
    
    /** Create a new Frame */
    public function JPGFrame(raw:ByteArray, callback:Object)
    {
        this.raw=raw;
        this.callback=callback;
    }
    
    /** Decode Raw Source */
    public function parse():void
    {
        var l:Loader=new Loader();
        var onComplete:Function=function(e:Event):void {
            cleanUp();
            try
            {
                callback.onComplete((l.content as Bitmap).bitmapData);
            }
            catch (e:Error)
            {
                callback.onError(e);
            }
        };
        var onError:Function=function(err:IOErrorEvent):void {
            cleanUp();
            callback.onError(new Error(err.text, err.errorID));
        };
        var cleanUp:Function=function():void {
            l.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
            l.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
        };
        l.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
        l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
        l.loadBytes(this.raw);
    }
}