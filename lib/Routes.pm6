use Cro::HTTP::Router;
use Cro::HTTP::Router::WebSocket;
use JSON::Fast;
use LearnPerl6;

sub routes(LearnPerl6 $learn-perl6) is export {
    route {
        get -> { static 'static/index.html' }

        get -> 'js', *@path { static 'static/js', @path }
        get -> 'css', *@path { static 'static/css', @path }

        post -> 'runUserCode' {
            request-body -> (:$text) {
                $learn-perl6.run-user-code($text);
                response.status = 204;
            }
        }

        post -> 'response', Int $id, 'agree' {
            $learn-perl6.agree($id);
            response.status = 204;
            CATCH {
                when X::LearnPerl6::NoSuchId {
                    not-found;
                }
            }
        }

        post -> 'response', Int $id, 'disagree' {
            $learn-perl6.disagree($id);
            response.status = 204;
            CATCH {
                when X::LearnPerl6::NoSuchId {
                    not-found;
                }
            }
        }

        post -> 'lesson', Int $id, 'previous' {
            $learn-perl6.previousLesson($id);
            response.status = 204;
            CATCH {
                when X::LearnPerl6::NoSuchId {
                    not-found;
                }
            }
        }

        post -> 'lesson', Int $id, 'next' {
            $learn-perl6.nextLesson($id);
            response.status = 204;
            CATCH {
                when X::LearnPerl6::NoSuchId {
                    not-found;
                }
            }
        }

        get -> 'latest-responses' {
            web-socket -> $incoming {
                supply whenever $learn-perl6.latest-responses -> $response {
                    emit to-json {
                        WS_ACTION => True,
                        action => {
                            type => 'LATEST_RESPONSE',
                            id => $response.id,
                            text => $response.response
                        }
                    } 
                }
            }
        }

        get -> 'top-responses' {
            web-socket -> $incoming {
                supply whenever $learn-perl6.top-responses -> @responses {
                    emit to-json {
                        WS_ACTION => True,
                        action => {
                            type => 'UPDATE_TOP_RESPONSES',
                            responses => [@responses.map: -> $response {
                                {
                                    id => $response.id,
                                    text => $response.response,
                                    agreed => $response.agreed,
                                    disagreed => $response.disagreed
                                }
                            }]
                        }
                    }
                }
            }
        }
    }
}
