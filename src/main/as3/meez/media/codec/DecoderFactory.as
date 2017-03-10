package meez.media.codec 
{

import flash.utils.ByteArray;

import meez.media.codec.gif.GIFStreamDecoder;
import meez.media.codec.jpg.JPGStreamDecoder;

public class DecoderFactory extends StreamDecoder
{
    // Instance vars
    
    /** Internal Decoder */
    protected var decoder:StreamDecoder;
    
    /** Souce Data */
    protected var data:ByteArray;

    // Public methods
    
    /** Create a new DecoderFactory */
    public function DecoderFactory(out:FrameConsumer) 
    {
        super(out);
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
        try
        {
            this.data.position=0;
            
            var b1:int=this.data.readByte() & 0xFF;
            var b2:int=this.data.readByte() & 0xFF;
                
            if (b1==0x47 && b2==0x49)
                this.decoder=new GIFStreamDecoder(this.out);
            
            if (b1==0xFF && b2==0xD8)
                this.decoder=new JPGStreamDecoder(this.out);
                
            // No appropriate stream decoder implemented
            if (this.decoder==null)
            {
                this.out.onError(new Error("Unrecognized Image Type", 404));
                return;
            }
            
            // Reset bytes after reading
            this.data.position=0;
            this.decoder.onData(this.data);
            this.decoder.onComplete();
        }
        catch (e:Error)
        {
            this.out.onError(e);
        }
    }

}
}