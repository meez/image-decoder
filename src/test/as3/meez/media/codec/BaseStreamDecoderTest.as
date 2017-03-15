package meez.media.codec 
{

import asunit.framework.AsynchronousTestCase;
import flash.events.Event;
import flash.utils.ByteArray;
import meez.media.codec.DataConsumer;
import mockolate.prepare;

public class BaseStreamDecoderTest extends AsynchronousTestCase
{

    // Public methods
    
    /** Create a new BaseStreamDecoderTest */
    public function BaseStreamDecoderTest()
    {
        super();
    }
    
    /** Setup */
    public override function run():void
    {
        prepare(FrameConsumer).addEventListener(Event.COMPLETE,super.completeHandler);

        super.run();
    }

    /** Ready */
    protected override function setDataSource(e:Event):void
    {
        trace("Mockolate ready");
    }

    /** Stream resource to decoder */
    public static function streamResource(raw:ByteArray, sink:DataConsumer):void
    {
        sink.onData(raw);
        sink.onComplete();
    }
}

}