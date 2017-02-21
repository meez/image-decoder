package meez.media.codec
{

import flash.display.BitmapData;

/** Frame of data */
public class Frame
{
    // Instance variables

    /** Content-type */
    public var contentType:String;

    /** Data */
    public var data:*;

    // Public methods

    /** Create new Frame */
    public function Frame(contentType:String, data:*)
    {
        this.contentType=contentType;
        this.data=data;
    }

    /** Return string representation */
    public function toString():String
    {
        return "Frame(contentType="+contentType+",data="+data+")";
    }

    /** Dispose */
    public function dispose():void
    {
        if (this.data is BitmapData)
        {
            (this.data as BitmapData).dispose();
        }

        this.data=null;
    }

    /** Release frame */
    public function release():void
    {
        // No ref-counting, auto-dispose
        dispose();
    }
}

}