use LearnPerl6;
use Test;

my $learn-perl6 = LearnPerl6.new;
lives-ok { $learn-perl6.run-user-code('say "First code"') },
    'Can add a tip';
lives-ok { $learn-perl6.run-user-code('say "Second code"') },
    'Can add another tip';
given $learn-perl6.latest-responses.head(2).list -> @tips {
    is @tips[0].response, 'Second code',
        'Correct first tip retrieved on initial tap of latest-tips';
    is @tips[1].response, 'First code',
        'Correct second tip retrieved on initial tap latest-tips';
}
react {
    whenever $learn-perl6.latest-responses.skip(2).head(1) {
        is .response, 'Third code',
            'Get new tips emitted live';
    }
    $learn-perl6.run-user-code('say "Third code"');
}

given $learn-perl6.latest-responses.head(3).list -> @tips {
    $learn-perl6.agree(@tips[0].id) for ^3;
    $learn-perl6.agree(@tips[1].id) for ^4;
    $learn-perl6.disagree(@tips[1].id) for ^10;
    $learn-perl6.agree(@tips[2].id) for ^2;
}
given $learn-perl6.top-responses().list[0] { # XXX JMG note the argument vanished
#given $learn-perl6.top-responses(1).list[0] {
    is .[0].response, 'Third code',
        'Most agreeable tip first';
    is .[1].response, 'First code',
        'Next most agreeable tip second';
    is .[2].response, 'Second code',
        'Least agreeable tip third';
}
throws-like { $learn-perl6.agree(99999) }, X::LearnPerl6::NoSuchId,
    'Correct exception on no such tip';

my $new-tip-id;
react {
    whenever $learn-perl6.top-responses.skip(1).head(1) {
        is .[0].response, 'Third code',
            'After adding a tip, correct order (1)';
        is .[1].response, 'First code',
            'After adding a tip, correct order (2)';
        is .[2].response, 'Fourth code',
            'After adding a tip, correct order (3)';
        is .[3].response, 'Second code',
            'After adding a tip, correct order (4)';
        $new-tip-id = .[2].id;
    }
    $learn-perl6.run-user-code('say "Fourth code"');
}
ok $new-tip-id, 'New tip ID seen in top sorted tips';

react {
    whenever $learn-perl6.top-responses.skip(5).head(1) {
        is .[0].response, 'Fourth code',
            'After agrees, order updated';
    }
    $learn-perl6.agree($new-tip-id) for ^5;
}

done-testing;
