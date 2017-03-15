package meez.media.codec 
{

import flash.events.Event;
import flash.utils.ByteArray;
import mockolate.nice;
import mockolate.prepare;
import mockolate.received;
import mockolate.stub;
import org.hamcrest.assertThat;

public class TestAutoDetectDecoder extends BaseStreamDecoderTest
{
    // Definitions

    /** 18 Frame GIF Image */
    [Embed(source="/gif/lucy-animated.gif", mimeType="application/octet-stream")]
    private static const LUCY_ANIMATED:Class;
    
    /** JPG Image */
    [Embed(source="/jpg/lucy-static.jpg",mimeType="application/octet-stream")]
    private static const LUCY_STATIC:Class;
    
    // Public methods
    
    /** Run */
    override public function run():void 
    {
        prepare(FrameConsumer, OutputTracker).addEventListener(Event.COMPLETE, super.completeHandler);
    }
    
    // Tests
    
    [Test]
    public function testUnrecognizedImage():void
    {
        var output:FrameConsumer=new OutputTracker(function():void {
            fail("expected to fail")
        },addAsync(function(reason:String):void {
            trace("expected failure: "+reason);
        }));
        var decoder:AutoDetectDecoder=new AutoDetectDecoder(output);
        
        // Unrecognized image type
        var data:ByteArray=new ByteArray();
        data.writeByte(0xdead);
        data.writeByte(0xbeef);
        
        streamResource(data, decoder);
    }
    
    [Test]
    public function testGIF():void
    {
        var success:Function=addAsync(function():void {
            // Animated Lucy has 18 Frames - ensure they are all accounted for
            assertThat(output, received().method("onFrame").times(18));
            assertThat(output, received().method("onComplete").once());
        });
        
        var output:OutputTracker=nice(OutputTracker, "output", [success, fail]);
        stub(output).method("onFrame").callsSuper();
        stub(output).method("onComplete").callsSuper();
        stub(output).method("onError").callsSuper();
        var decoder:AutoDetectDecoder=new AutoDetectDecoder(output);
        
        streamResource(new LUCY_ANIMATED(), decoder);
    }
    
    [Test]
    public function testJPG():void
    {
        var success:Function=addAsync(function():void {
            // Only single frame in jpg
            assertThat(output, received().method("onFrame").once());
            assertThat(output, received().method("onComplete").once());
        });
        
        var output:FrameConsumer=nice(OutputTracker, "output", [success, fail]);
        stub(output).method("onFrame").callsSuper();
        stub(output).method("onComplete").callsSuper();
        stub(output).method("onError").callsSuper();
        var decoder:AutoDetectDecoder=new AutoDetectDecoder(output);
        
        streamResource(new LUCY_STATIC(), decoder);
    }
    
    [Test]
    public function testDripFeed():void
    {
        // Tests AutoDetect Decoder 1 byte at a time
        
        var success:Function=addAsync(function():void {
            // Only single frame in jpg
            assertThat(output, received().method("onFrame").once());
            assertThat(output, received().method("onComplete").once());
        });
        
        var output:FrameConsumer=nice(OutputTracker, "output", [success, fail]);
        stub(output).method("onFrame").callsSuper();
        stub(output).method("onComplete").callsSuper();
        stub(output).method("onError").callsSuper();
        var decoder:AutoDetectDecoder=new AutoDetectDecoder(output);
        var bytes:ByteArray=new LUCY_STATIC();
        var buffer:ByteArray=new ByteArray();
        bytes.position=0;
        for (var i:int=0; i<bytes.bytesAvailable; i++)
        {
            buffer.writeBytes(bytes, i, 1);
            decoder.onData(buffer);
        }
        decoder.onComplete();
    }
}

}