use LearnPerl6;
use Test;

my $learn-perl6 = LearnPerl6.new;
lives-ok { $learn-perl6.run-user-code('The lamb kebabs are good!') },
    'Can add a tip';
lives-ok { $learn-perl6.run-user-code('Not so keen on the fish burrito!') },
    'Can add another tip';
given $learn-perl6.latest-responses.head(2).list -> @tips {
    is @tips[0].tip, 'Not so keen on the fish burrito!',
        'Correct first tip retrieved on initial tap of latest-tips';
    is @tips[1].tip, 'The lamb kebabs are good!',
        'Correct second tip retrieved on initial tap latest-tips';
}
react {
    whenever $learn-perl6.latest-responses.skip(2).head(1) {
        is .tip, 'Try the vanilla stout for sure',
            'Get new tips emitted live';
    }
    $learn-perl6.run-user-code('Try the vanilla stout for sure');
}

given $learn-perl6.latest-responses.head(3).list -> @tips {
    $learn-perl6.agree(@tips[0].id) for ^3;
    $learn-perl6.agree(@tips[1].id) for ^4;
    $learn-perl6.disagree(@tips[1].id) for ^10;
    $learn-perl6.agree(@tips[2].id) for ^2;
}
given $learn-perl6.top-responses().list[0] { # XXX JMG note the argument vanished
#given $learn-perl6.top-responses(1).list[0] {
    is .[0].tip, 'Try the vanilla stout for sure',
        'Most agreeable tip first';
    is .[1].tip, 'The lamb kebabs are good!',
        'Next most agreeable tip second';
    is .[2].tip, 'Not so keen on the fish burrito!',
        'Least agreeable tip third';
}
throws-like { $learn-perl6.agree(99999) }, X::LearnPerl6::NoSuchId,
    'Correct exception on no such tip';

my $new-tip-id;
react {
    whenever $learn-perl6.top-responses.skip(1).head(1) {
        is .[0].tip, 'Try the vanilla stout for sure',
            'After adding a tip, correct order (1)';
        is .[1].tip, 'The lamb kebabs are good!',
            'After adding a tip, correct order (2)';
        is .[2].tip, 'The pau bahji is super spicy',
            'After adding a tip, correct order (3)';
        is .[3].tip, 'Not so keen on the fish burrito!',
            'After adding a tip, correct order (4)';
        $new-tip-id = .[2].id;
    }
    $learn-perl6.run-user-code('The pau bahji is super spicy');
}
ok $new-tip-id, 'New tip ID seen in top sorted tips';

react {
    whenever $learn-perl6.top-responses.skip(5).head(1) {
        is .[0].tip, 'The pau bahji is super spicy',
            'After agrees, order updated';
    }
    $learn-perl6.agree($new-tip-id) for ^5;
}

done-testing;
