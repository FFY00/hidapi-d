module hidapi.error;

class HidError : Exception
{

    /**
     * Default constructor
     */
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }

}