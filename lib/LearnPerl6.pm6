use OO::Monitors;

class Response {
    has Int $.id is required;
    has Str $.response is required;
    has Int $.agreed = 0;
    has Int $.disagreed = 0;

    method agree() {
        self.clone(agreed => $!agreed + 1)
    }

    method disagree() {
        self.clone(disagreed => $!disagreed + 1)
    }
}

class X::LearnPerl6::NoSuchId is Exception {
    has $.id;
    method message() { "No response with ID '$!id'" }
}

monitor LearnPerl6 {
    has Int $!next-id = 1;
    has Response %!responses-by-id{Int};
    has Supplier $!latest-responses = Supplier.new;
    has Supplier $!response-change = Supplier.new;

    method run-user-code(Str $response --> Nil) {
        my $id = $!next-id++;
        my $new-response = Response.new(:$id, :$response);
        %!responses-by-id{$id} = $new-response;
        start $!latest-responses.emit($new-response);
    }

    method latest-responses(--> Supply) {
        my @latest-existing = %!responses-by-id.values.sort(-*.id).head(50);
        supply {
            whenever $!latest-responses {
                .emit;
            }
            .emit for @latest-existing;
        }
    }

    method agree(Int $response-id --> Nil) {
        self!with-response: $response-id, -> $response-ref is rw {
            $response-ref .= agree;
        }
    }

    method disagree(Int $response-id --> Nil) {
        self!with-response: $response-id, -> $response-ref is rw {
            $response-ref .= disagree;
        }
    }

    method !with-response(Int $response-id, &operation --> Nil) {
        with %!responses-by-id{$response-id} -> $response-ref is rw {
            operation($response-ref);
            start $!response-change.emit($response-ref<>);
        }
        else {
            X::LearnPerl6::NoSuchId.new(id => $response-id).throw;
        }
    }

    method top-responses(--> Supply) {
        my %initial-responses = %!responses-by-id;
        supply {
            my %current-responses = %initial-responses;
            sub emit-latest-sorted() {
                emit [%current-responses.values.sort({ .disagreed - .agreed }).head(50)]
            }
            whenever Supply.merge($!latest-responses.Supply, $!response-change.Supply) {
                %current-responses{.id} = $_;
                emit-latest-sorted;
            }
            emit-latest-sorted;
        }
    }
}
