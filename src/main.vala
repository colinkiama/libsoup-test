using NoodleSoup;

public static int main (string[] args) {
    InetAddress localHostAddress = new InetAddress.from_bytes ({127, 0, 0, 1}, 
                                    SocketFamily.IPV4);
    InetSocketAddress socketAddress = new InetSocketAddress (localHostAddress,
                                                             8088);
    
    try {
        MainLoop loop = new MainLoop ();

        NoodleSoupServer server = new NoodleSoupServer ();
        // 0 is used as the value for the server listen option parameter
        // because there isn't a defined enum for no options.
        server.listen (socketAddress, 0);

        loop.run ();
    } catch (Error e) {
        error (
            "Message: %s\nError Code: %d\nErrors occured: %" + uint32.FORMAT
            + "\n",
            e.message, 
            e.code
        );
    }

    return 0;
}
