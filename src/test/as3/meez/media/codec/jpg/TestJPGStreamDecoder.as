package meez.media.codec.jpg 
{

import asunit.framework.AsynchronousTestCase;
import flash.utils.ByteArray;
import meez.media.codec.BaseStreamDecoderTest;
import meez.media.codec.FrameConsumer;
import meez.media.codec.OutputTracker;
import meez.media.codec.jpg.JPGStreamDecoder;
import meez.media.codec.BaseStreamDecoderTest;

public class TestJPGStreamDecoder extends BaseStreamDecoderTest
{
    // Definitions
    
    /** Test Image */
    [Embed(source="/jpg/lucy-static.jpg",mimeType="application/octet-stream")]
    private static const LUCY_STATIC:Class;
    
    // Tests
    
    [Test]
    public function testRubbish():void
    {
        var output:FrameConsumer=new OutputTracker(function():void {
            fail("expected to fail")
        },addAsync(function(reason:String):void {
            trace("expected failure: "+reason);
        }));
        
        var decoder:JPGStreamDecoder=new JPGStreamDecoder(output);

        var data:ByteArray=new ByteArray();
        data.writeInt(0xdead);
        data.writeInt(0xbeef);

        streamResource(data, decoder);
    }

    [Test]
    public function testImage():void
    {
        var output:FrameConsumer=new OutputTracker(addAsync(function():void {}),fail);
        var decoder:JPGStreamDecoder=new JPGStreamDecoder(output);

        streamResource(new LUCY_STATIC(), decoder);
    }
}

}