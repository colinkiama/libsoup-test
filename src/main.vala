using NoodleSoup;

public static int main (string[] args) {
    InetAddress localHostAddress = new InetAddress.from_bytes ({127, 0, 0, 1}, SocketFamily.IPV4);
    InetSocketAddress socketAddress = new InetSocketAddress (localHostAddress, 8080);
    
    try {
        MainLoop loop = new MainLoop ();

        NoodleSoupServer server = new NoodleSoupServer ();
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

    print ("A new Vala app\n");
    return 0;
}
