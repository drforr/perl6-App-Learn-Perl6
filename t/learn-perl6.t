use LearnPerl6;
use Test;

my $learn-perl6 = LearnPerl6.new;
lives-ok { $learn-perl6.run-user-code('say "First code"') },
    'Can add user code';
lives-ok { $learn-perl6.run-user-code('say "Second code"') },
    'Can add more user code';
given $learn-perl6.latest-responses.head(2).list -> @responses {
    is @responses[0].response, 'Second code',
        'Correct first response retrieved on initial tap of latest-responses';
    is @responses[1].response, 'First code',
        'Correct second response retrieved on initial tap latest-responses';
}
react {
    whenever $learn-perl6.latest-responses.skip(2).head(1) {
        is .response, 'Third code',
            'Get new responses emitted live';
    }
    $learn-perl6.run-user-code('say "Third code"');
}

given $learn-perl6.latest-responses.head(3).list -> @responses {
    $learn-perl6.agree(@responses[0].id) for ^3;
    $learn-perl6.agree(@responses[1].id) for ^4;
    $learn-perl6.disagree(@responses[1].id) for ^10;
    $learn-perl6.agree(@responses[2].id) for ^2;
}
given $learn-perl6.top-responses().list[0] { # XXX JMG note the argument vanished
#given $learn-perl6.top-responses(1).list[0] {
    is .[0].response, 'Third code',
        'Most agreeable response first';
    is .[1].response, 'First code',
        'Next most agreeable response second';
    is .[2].response, 'Second code',
        'Least agreeable response third';
}
throws-like { $learn-perl6.agree(99999) }, X::LearnPerl6::NoSuchId,
    'Correct exception on no such response';

my $new-response-id;
react {
    whenever $learn-perl6.top-responses.skip(1).head(1) {
        is .[0].response, 'Third code',
            'After adding a response, correct order (1)';
        is .[1].response, 'First code',
            'After adding a response, correct order (2)';
        is .[2].response, 'Fourth code',
            'After adding a response, correct order (3)';
        is .[3].response, 'Second code',
            'After adding a response, correct order (4)';
        $new-response-id = .[2].id;
    }
    $learn-perl6.run-user-code('say "Fourth code"');
}
ok $new-response-id, 'New response ID seen in top sorted responses';

react {
    whenever $learn-perl6.top-responses.skip(5).head(1) {
        is .[0].response, 'Fourth code',
            'After agrees, order updated';
    }
    $learn-perl6.agree($new-response-id) for ^5;
}

done-testing;
