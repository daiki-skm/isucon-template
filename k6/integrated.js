// 各ファイルからシナリオ関数を import
import initialize from "./initialize.js";
import comment from "./comment.js";
import postimage from "./postimage.js";

// k6が各関数を実行できるようにexport
export { initialize, comment, postimage };

// 複数のシナリオを組み合わせて実行するオプションの定義
export const options = {
        scenarios: {
                initialize: {
                        executor: "shared-iterations",
                        vus: 1,
                        iterations: 1,
                        exec: "initialize",
                        maxDuration: "10s",
                },
                comment: {
                        executor: "constant-vus",
                        vus: 4,
                        duration: "30s",
                        exec: "comment",
                        startTime: "12s",
                },
                postImage: {
                        executor: "constant-vus",
                        vus: 2,
                        duration: "30s",
                        exec: "postimage",
                        startTime: "12s",
                },
        },
};

// k6が実行する関数。定義は空で良い
export default function() { }