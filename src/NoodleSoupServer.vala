namespace NoodleSoup {
	public class NoodleSoupServer : Soup.Server {
		private int access_counter = 0;
		private const string CORSAllowOriginKey = "Access-Control-Allow-Origin";
		private const string CORSAllowMethodsKey = "Access-Control-Allow-Methods";
		private const string CORSAllowHeadersKey = "Access-Control-Allow-Headers";
		private const string CORSAllowCredentialsKey = "Access-Control-Allow-Credentials";


		public NoodleSoupServer () {
			assert (this != null);

			// Links:
			//   http://localhost:8088/about.html
			//   http://localhost:8088/index.html
			//   http://localhost:8088/
			// this. The preflight request suffered any kind of networking error that might ordinarily occur. add_handler ("/about.html", about_handler);
			// this.add_handler ("/index.html", root_handler);
			// this.add_handler ("/", root_handler);

			// Links:
			// http://localhost:8088/*
			this.add_handler (null, default_handler);
		}

		private static void default_handler (Soup.Server server, 
				Soup.Message msg, string path, GLib.HashTable? query, 
				Soup.ClientContext client) {
			unowned NoodleSoupServer self = server as NoodleSoupServer;

			uint id = self.access_counter++;
			print ("Default handler start (%u)\n", id);

			if (msg.method == "OPTIONS") {
				
				Timeout.add_seconds (0, () => {
					print ("Handling OPTIONS method");

					add_cors_headers (msg);

					self.unpause_message (msg);

					return false;
				}, Priority.DEFAULT);
				
				self.pause_message (msg);
			}

			else {
				msg.got_body.connect (default_handler_got_body);


				// Simulate asynchronous input / time consuming operations:
				// See GLib.IOSchedulerJob for time consuming operations
				Timeout.add_seconds (0, () => {
					add_cors_headers (msg);
					
					string html_head = "<head><title>Index</title></head>";
					string html_body = "<body><h1>Index:</h1></body>";
					msg.set_response ("text/html", Soup.MemoryUse.COPY, 
						"<html>%s%s</html>".printf (html_head, html_body).data);

					// Resumes HTTP I/O on msg:
					self.unpause_message (msg);
					print ("Default handler end (%u)\n", id);
					return false;
				}, Priority.DEFAULT);

				// Pauses HTTP I/O on msg:
				self.pause_message (msg);
			}
			
		}

		private static void default_handler_got_body (Soup.Message msg ) {
			uint8[] bodyData = msg.request_body.flatten().data;
			print ("Body:\n%s", (string) bodyData);
		}

		private static void add_cors_headers (Soup.Message msg) {
			Soup.MessageHeaders headers = msg.response_headers;
			// TODO: Encapsulate CORS Headers into a configuration object
			// or builder.
			headers.append (CORSAllowOriginKey, "*");
			headers.append (CORSAllowMethodsKey, 
				"PUT, GET, POST, DELETE, PATCH, OPTIONS");
			headers.append (CORSAllowHeadersKey, "*");
			headers.append (CORSAllowCredentialsKey, "true");
			msg.set_status (Soup.Status.OK);
		}
	}
}