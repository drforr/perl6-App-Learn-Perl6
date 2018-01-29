use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Routes;
use LearnPerl6;

my $learn-perl6 = LearnPerl6.new;
my $application = routes($learn-perl6);

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1>,
    host => %*ENV<LEARN_PERL6_HOST> ||
        die("Missing LEARN_PERL6_HOST in environment"),
    port => %*ENV<LEARN_PERL6_PORT> ||
        die("Missing LEARN_PERL6_PORT in environment"),
    :$application,
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
    ]
);
$http.start;
say "Listening at http://%*ENV<LEARN_PERL6_HOST>:%*ENV<LEARN_PERL6_PORT>";
react {
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}
