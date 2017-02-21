package meez.media.codec
{

import flash.utils.ByteArray;

/** Consumer interface for data */
public interface DataConsumer
{
    /** Consume next buffer of data */
    function onData(data:ByteArray):void;

    /** Stream complete */
    function onComplete():void;

    /** Stream failed */
    function onError(e:Error):void;
}

}


