package meez.media.codec.jpg 
{

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.ByteArray;

/** JPG Decoder */
public class JPGDecoder extends EventDispatcher
{
    /** JPG Frame Data */
    public var frames:Array;
    
    /** Create a new JPG Decoder */
    public function JPGDecoder() 
    {
        this.frames=[];
    }
    
    /** Decode */
    public function decode(data:ByteArray):void 
    {
        var f:Frame=new Frame(data, {onComplete:onFrameComplete, onError:onDecodeError});
        f.parse();
    }
    
    // Events
    
    /** On Frame Decode */
    protected function onFrameComplete(frame:Frame):void
    {
        this.frames.push(frame);
        dispatchEvent(new Event(Event.COMPLETE));
    }
    
    /** On Image Decode Error */
    protected function onDecodeError(msg:String, code:Number):void
    {
        dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, msg, code));
    }
}

}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.utils.ByteArray;

/** Image Frame Object */
class Frame
{
    /** Bitmap Data */
    public var bitmapData:BitmapData;
    
    /** Callback Object */
    private var callback:Object;
    
    /** Raw Source */
    private var raw:ByteArray;
    
    /** Create a new Frame */
    public function Frame(raw:ByteArray, callback:Object)
    {
        this.raw=raw;
        this.callback=callback;
    }
    
    /** Decode Raw Source */
    public function parse():void
    {
        var l:Loader=new Loader();
        var f:Frame=this;
        var onComplete:Function=function(e:Event):void {
            cleanUp();
            f.bitmapData=(l.content as Bitmap).bitmapData;
            callback.onComplete(f);
        };
        var onError:Function=function(e:IOErrorEvent):void {
            cleanUp();
            callback.onError("Cannot parse jpg source bytes", 400);
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
