import $ from 'jquery';

export const CHANGE_RESPONSE_TEXT = 'CHANGE_RESPONSE_TEXT';
export const ADD_RESPONSE = 'ADD_RESPONSE';
export const LATEST_RESPONSE = 'LATEST_RESPONSE';
export const UPDATE_TOP_RESPONSES = 'UPDATE_TOP_RESPONSES';
export const AGREE = 'AGREE';
export const DISAGREE = 'DISAGREE';
export const PREVIOUS_LESSON = 'PREVIOUS_LESSON';
export const NEXT_LESSON = 'NEXT_LESSON';

export function changeResponseText(text) {
    return { type: CHANGE_RESPONSE_TEXT, text };
}
export function runUserCode() {
    return (dispatch, getState) => {
        $.ajax({
            url: '/runUserCode',
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
            url: '/response/' + id + '/agree',
            type: 'POST',
            success: () => dispatch({ type: AGREE, id })
        });
    };
}
export function disagree(id) {
    return dispatch => {
        $.ajax({
            url: '/response/' + id + '/disagree',
            type: 'POST',
            success: () => dispatch({ type: DISAGREE, id })
        });
    };
}
export function previousLesson(lessonID) {
    return dispatch => {
        $.ajax({
            url: '/lesson/' + lessonID + '/previous',
            type: 'POST',
            success: () => dispatch({ type: PREVIOUS_LESSON, lessonID })
        });
    };
}
export function nextLesson(lessonID) {
    return dispatch => {
        $.ajax({
            url: '/lesson/' + lessonID + '/next',
            type: 'POST',
            success: () => dispatch({ type: NEXT_LESSON, lessonID })
        });
    };
}
