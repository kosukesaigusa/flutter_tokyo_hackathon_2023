import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

/** 1 つのルームにおける最大の回答人数。 */
const maxAnswerCont = 10

/**
 * 新しい completedUser ドキュメントが作成されたときに実行される関数。
 * そのユーザーが作成されたことで所定の回答人数を超えた場合に room を終了する。
 */
export const onCreateCompletedUser = functions
    .region(`asia-northeast1`)
    .firestore.document(`/rooms/{roomId}/completedUsers/{userId}`)
    .onCreate(async (snapshot, context) => {
        const roomId = context.params.roomId
        const roomDs = await admin
            .firestore()
            .collection(`rooms`)
            .doc(roomId)
            .get()
        const room = roomDs.data()
        const maxAnswerCount = room?.maxAnswerCount ?? maxAnswerCont

        const completedUsersQs = await admin
            .firestore()
            .collection(`rooms`)
            .doc(roomId)
            .collection(`completedUsers`)
            .get()
        const completedUsersCount = completedUsersQs.docs.length
        if (completedUsersCount < maxAnswerCount) {
            return
        }

        try {
            await roomDs.ref.update({ roomStatus: `completed` })
        } catch (e) {
            functions.logger.error(
                `ルームを completed にする処理に失敗しました。${e}`
            )
        }
    })
