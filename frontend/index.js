import React from 'react';
import { render } from 'react-dom';
import { createStore, applyMiddleware } from 'redux';
import { Provider, connect } from 'react-redux';
import thunkMiddleware from 'redux-thunk';
import WSAction from 'redux-websocket-action';
import * as Actions from './actions';
import { tipsyReducer } from './reducer';
import { UnControlled as CodeMirror } from 'react-codemirror2';

var SendUserCode = props => (
    <div>
        <h2>Got a tip?</h2>
        <div>
          <CodeMirror value={props.tipText}
                      options={{
                        mode: 'perl',
                        theme: 'materials',
                        lineNumbers: true
                      }}
                      onChange={(editor,data,value) => {
			props.onChangeTipText(value)
                      }}
          />
        </div>
        <input type="button" value="Add Tip" onClick={props.onAddTip} />
    </div>
);

var ResponseList = props => (
    <div>
        <h2>{props.heading}</h2>
        <ul>
        {props.tips.map(t => <Response key={t.id} {...props} {...t} />)}
        </ul>
    </div>
);

var Response = props => (
    <li>
        {props.text} [<a href="#"
                         onClick={() => props.onAgree(props.id)}>Agree</a>]
        [<a href="#" onClick={() => props.onDisagree(props.id)}>Disagree</a>]
    </li>
);

var App = props => (
    <div>
        <SendUserCode tipText={props.tipText}
            onChangeTipText={props.onChangeTipText}
            onAddTip={props.onAddTip} />
        <ResponseList heading="Latest Tips" tips={props.latestTips}
            onAgree={props.onAgree} onDisagree={props.onDisagree} />
        <ResponseList heading="Top Tips" tips={props.topTips}
            onAgree={props.onAgree} onDisagree={props.onDisagree} />
    </div>
);

function mapProps(state) {
    return state;
}
function mapDispatch(dispatch) {
    return {
        onChangeTipText: text => dispatch(Actions.changeTipText(text)),
        onAddTip: text => dispatch(Actions.addTip()),
        onAgree: id => dispatch(Actions.agree(id)),
        onDisagree: id => dispatch(Actions.disagree(id)),
    };
}

let store = createStore(tipsyReducer, applyMiddleware(thunkMiddleware));

['latest-tips', 'top-tips'].forEach(endpoint => {
    let host = window.location.host;
    let wsAction = new WSAction(store, 'ws://' + host + '/' + endpoint, {
        retryCount:3,
        reconnectInterval: 3
    });
    wsAction.start();
});

let ConnectedApp = connect(mapProps, mapDispatch)(App);
render(
    <Provider store={store}>
        <ConnectedApp />
    </Provider>,
    document.getElementById('app'));

render(
    <div id="sidedrawer" class="mui--no-user-select">
      <div id="sidedrawer-brand" class="mui--appbar-line-height">
        <span class="mui--text-title">Learn Perl 6 Online</span>
      </div>
      <div class="mui-divider"></div>
      <ul>
        <li>
          <strong>Intro to the Tour</strong>
          <ul>
            <li><a href="#">Item 1</a></li>
            <li><a href="#">Item 2</a></li>
            <li><a href="#">Item 3</a></li>
          </ul>
        </li>
        <li>
          <strong>Learning Perl 6</strong>
          <ul>
            <li><a href="#">Item 1</a></li>
            <li><a href="#">Item 2</a></li>
            <li><a href="#">Item 3</a></li>
          </ul>
        </li>
        <li>
          <strong>Programming Perl 6</strong>
          <ul>
            <li><a href="#">Item 1</a></li>
            <li><a href="#">Item 2</a></li>
            <li><a href="#">Item 3</a></li>
          </ul>
        </li>
        <li>
          <strong>Advanced Perl 6</strong>
          <ul>
            <li><a href="#">Item 1</a></li>
            <li><a href="#">Item 2</a></li>
            <li><a href="#">Item 3</a></li>
          </ul>
        </li>
      </ul>
    </div>,
    document.getElementById('sidebar'));

render(
    <header id="header">
      <div class="mui-appbar mui--appbar-line-height">
        <div class="mui-container-fluid">
          <a class="sidedrawer-toggle mui--visible-xs-inline-block mui--visible-sm-inline-block js-show-sidedrawer">☰</a>
          <a class="sidedrawer-toggle mui--hidden-xs mui--hidden-sm js-hide-sidedrawer">☰</a>
          <span class="mui--text-title mui--visible-xs-inline-block">Brand.io</span>
        </div>
      </div>
    </header>,
    document.getElementById('header'));

render(
      <footer>
        <div class="mui-container-fluid mui--text-center">
          Copyright 2018 Jeffrey Goff
          <a href="https://theperlfisher.blogspot.ro/">The Perl Fisher</a><br />
          Send me a <a href="https://github.com/drforr/perl6-App-Learn-Perl6.git">GitHub</a> pull request
        </div>
      </footer>,
    document.getElementById('footer'));
