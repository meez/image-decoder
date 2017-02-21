package {

import meez.media.codec.*;

import asunit.textui.TestRunner;

/** Test Runner */
public class RunTests extends TestRunner
{
    /** Create Suite */
    public function RunTests()
    {
        start(UnitTests, null, TestRunner.SHOW_TRACE);
    }
}

}
