import * as functions from 'firebase-functions'

/**
 * 新しい completedUser ドキュメントが作成されたときに実行される関数。
 * そのユーザーが作成されたことで所定の回答人数を超えた場合に room を終了する。
 */
export const onUpdateRoom = functions
    .region(`asia-northeast1`)
    .firestore.document(`/rooms/{roomId}`)
    .onUpdate(async (change, context) => {
        const newStatus = (change.after.data().roomStatus ?? ``) as string
        const previousStatus = (change.before.data().roomStatus ?? ``) as string
        if (newStatus !== `playing` || previousStatus !== `pending`) {
            functions.logger.info(
                `ルーム (${context.params.roomId}) の更新がありましたが roomStatus: pending → playing の更新ではありませんでした。`
            )
            return
        }
        try {
            functions.logger.info(
                `30 秒後にルーム (${context.params.roomId}) は completed になります`
            )
            await new Promise((resolve) => setTimeout(resolve, 30000))
            await change.after.ref.update({ roomStatus: `completed` })
        } catch (e) {
            functions.logger.error(
                `ルームを 30 秒後に completed にする処理に失敗しました。${e}`
            )
        }
    })
