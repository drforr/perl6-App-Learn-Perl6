import * as ActionTypes from './actions';

const initialState = {
    responseText: '',
    latestResponses: [],
    topResponses: []
};
export function learnPerl6Reducer(state = initialState, action) {
    switch (action.type) {
        case ActionTypes.CHANGE_RESPONSE_TEXT:
            return { ...state, responseText: action.text };
        case ActionTypes.ADD_RESPONSE:
            return { ...state, responseText: '' };
        case ActionTypes.LATEST_RESPONSE: {
            let response = { id: action.id, text: action.text };
            return {
                ...state,
                latestResponses: [response, ...state.latestResponses]
            };
        }
        case ActionTypes.UPDATE_TOP_RESPONSES:
            return {
                ...state,
                topResponses: action.responses
            };
        default:
            return state;
    }
}
