import com.example.test_twilio.TwilioApplication
import com.twilio.conversations.CallbackListener
import com.twilio.conversations.ErrorInfo
import com.twilio.conversations.StatusListener

typealias SuccessStatus = () -> Unit
typealias SuccessCallback<T> = (T) -> Unit
typealias ErrorCallback = (error: ErrorInfo) -> Unit

class ConversationsCallbackListener<T>(val fail: ErrorCallback = {},
                                       val success: SuccessCallback<T> = {}) : CallbackListener<T> {

    override fun onSuccess(p0: T) = success(p0)

    override fun onError(err: ErrorInfo) {
        fail(err)
    }
}

open class ConversationsStatusListener(val fail: ErrorCallback = {},
                                       val success: SuccessStatus = {}) : StatusListener {

    override fun onSuccess() = success()

    override fun onError(err: ErrorInfo) {
        fail(err)
    }
}


/**
 * Status listener that shows a toast with operation results.
 */
class ToastStatusListener(val okText: String, val errorText: String, fail: ErrorCallback = {},
                          success: SuccessStatus = {}) : ConversationsStatusListener(fail, success) {

    override fun onSuccess() {
        TwilioApplication.instance.showToast(okText)
        success()
    }
}
