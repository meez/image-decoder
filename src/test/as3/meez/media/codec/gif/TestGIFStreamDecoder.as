package meez.media.codec.gif
{

import asunit.framework.AsynchronousTestCase;
import meez.media.codec.BaseStreamDecoderTest;


import flash.events.Event;

import flash.utils.ByteArray;

import meez.media.codec.DataConsumer;
import meez.media.codec.FrameConsumer;
import meez.media.codec.OutputTracker;

import mockolate.prepare;

/** Unit-test for GIFStreamDecoder */
public class TestGIFStreamDecoder extends BaseStreamDecoderTest
{
    // Set

    [Embed(source="/gif/lucy-animated.gif", mimeType="application/octet-stream")]
    private static const LUCY_ANIMATED:Class;

    // Tests

    [Test]
    public function testRubbish():void
    {
        var output:FrameConsumer=new OutputTracker(function():void {
            fail("expected to fail")
        },addAsync(function(reason:String):void {
            trace("expected failure: "+reason);
        }));
        var decoder:GIFStreamDecoder=new GIFStreamDecoder(output);

        var data:ByteArray=new ByteArray();
        data.writeInt(0xdead);
        data.writeInt(0xbeef);

        streamResource(data, decoder);
    }

    [Test]
    public function testAnimation():void
    {
        var output:FrameConsumer=new OutputTracker(addAsync(function():void {}),fail);
        var decoder:GIFStreamDecoder=new GIFStreamDecoder(output);

        streamResource(new LUCY_ANIMATED(), decoder);
    }
}

}


