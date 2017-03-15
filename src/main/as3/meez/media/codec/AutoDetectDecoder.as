package meez.media.codec 
{

import flash.utils.ByteArray;

import meez.media.codec.gif.GIFStreamDecoder;
import meez.media.codec.jpg.JPGStreamDecoder;

public class AutoDetectDecoder extends StreamDecoder
{
    // Instance vars
    
    /** Internal Decoder */
    protected var decoder:StreamDecoder;
    
    /** Byte Buffer */
    protected var buffer:ByteArray;

    // Public methods
    
    /** Create a new DecoderFactory */
    public function AutoDetectDecoder(out:FrameConsumer) 
    {
        super(out);
        this.buffer=new ByteArray();
    }
        
    // DataConsumer Implementation
    
    /** Handle data */
    public override function onData(data:ByteArray):void
    {
        // Already assigned a decoder
        if (this.decoder!=null)
        {
            this.decoder.onData(data);
            return;
        }
        
        this.buffer.writeBytes(data, 0, data.bytesAvailable);
        if (GIFStreamDecoder.matchesHeader(this.buffer))
        {
            this.decoder=new GIFStreamDecoder(this.out);
        }
            
        if (JPGStreamDecoder.matchesHeader(this.buffer))
        {
            this.decoder=new JPGStreamDecoder(this.out);
        }
        
        // Decoder set
        if (this.decoder!=null)
        {
            //TODO: Revisit this when actual streaming data is used -DW
            this.buffer.clear();
            onData(data);
        }
    }

    /** Complete */
    public override function onComplete():void
    {
        if (this.decoder==null)
        {
            this.out.onError(new Error("No decoder created", 400));
            return;
        }
            
        this.decoder.onComplete();
    }

}
}