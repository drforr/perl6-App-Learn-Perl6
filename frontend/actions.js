import $ from 'jquery';

export const CHANGE_RESPONSE_TEXT = 'CHANGE_RESPONSE_TEXT';
export const ADD_RESPONSE = 'ADD_RESPONSE';
export const LATEST_RESPONSE = 'LATEST_RESPONSE';
export const UPDATE_TOP_RESPONSES = 'UPDATE_TOP_RESPONSES';
export const AGREE = 'AGREE';
export const DISAGREE = 'DISAGREE';

export function changeResponseText(text) {
    return { type: CHANGE_RESPONSE_TEXT, text };
}
export function addResponse() {
    return (dispatch, getState) => {
        $.ajax({
            url: '/tips',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ text: getState().responseText }),
            success: () => dispatch({ type: ADD_RESPONSE })
        });
    };
}
export function agree(id) {
    return dispatch => {
        $.ajax({
            url: '/tips/' + id + '/agree',
            type: 'POST',
            success: () => dispatch({ type: AGREE, id })
        });
    };
}
export function disagree(id) {
    return dispatch => {
        $.ajax({
            url: '/tips/' + id + '/disagree',
            type: 'POST',
            success: () => dispatch({ type: DISAGREE, id })
        });
    };
}
