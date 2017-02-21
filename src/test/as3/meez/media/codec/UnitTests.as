package meez.media.codec
{

import asunit.framework.TestResult;
import asunit.framework.TestSuite;

import flash.desktop.NativeApplication;

import flash.events.Event;

import meez.media.codec.gif.TestGIFStreamDecoder;

/** Unit-tests */
public class UnitTests extends TestSuite
{
    /** Create New UnitTests */
    public function UnitTests()
    {
        super();

        addEventListener(Event.COMPLETE,onTestComplete);

        addTest(new TestGIFStreamDecoder());
    }

    /** test complete event handler */
    private function onTestComplete(event:Event):void
    {
        var tr:TestResult=this.result as TestResult;

        trace("testComplete("+tr+")");

        NativeApplication.nativeApplication.exit(tr.wasSuccessful()?0:-1);
    }
}

}
