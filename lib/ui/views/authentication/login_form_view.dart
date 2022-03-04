import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:quicknotes/app/colors.dart';
import 'package:quicknotes/ui/views/authentication/login_form_viewmodel.dart';
import 'package:stacked/stacked.dart';

class LoginForm extends HookWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final email = useTextEditingController();
    final emailFocus = useFocusNode();
    final password = useTextEditingController();
    final passwordFocus = useFocusNode();

    void _fireFormChanged(FormViewModel model) => model.setData({
          'email': email.text,
          'password': password.text,
        });

    return ViewModelBuilder<LoginFormViewModel>.reactive(
        viewModelBuilder: () => LoginFormViewModel(),
        builder: (context, model, child) => Container(
                child: Form(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    //Email Field
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 3,
                              color: model.emailError
                                  ? Colors.red
                                  : AppColors.primaryDark)),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                        textAlignVertical: TextAlignVertical.center,
                        controller: email,
                        onChanged: (_) {
                          _fireFormChanged(model);
                          model.emailError = false;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) =>
                            FocusScope.of(context).requestFocus(passwordFocus),
                        focusNode: emailFocus,
                        maxLines: 1,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            isCollapsed: true,
                            alignLabelWithHint: true,
                            border: InputBorder.none,
                            label: Text(
                              'Email',
                              style: TextStyle(color: Color(0xFF819DAD)),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never),
                      ),
                    ),

                    SizedBox(height: 10),
                    //Password Field
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 3,
                              color: model.passwordError
                                  ? Colors.red
                                  : AppColors.primaryDark)),
                      child: TextFormField(
                        obscureText: true,
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                        textAlignVertical: TextAlignVertical.center,
                        controller: password,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (v) => model.sendForValidation(),
                        onChanged: (_) {
                          _fireFormChanged(model);
                          model.passwordError = false;
                        },
                        focusNode: passwordFocus,
                        maxLines: 1,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            isCollapsed: true,
                            alignLabelWithHint: true,
                            border: InputBorder.none,
                            label: Text(
                              'Password',
                              style: TextStyle(color: Color(0xFF819DAD)),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never),
                      ),
                    ),
                    model.showValidation
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Text(
                              model.validationMessage!,
                              style: TextStyle(
                                color: Color.fromARGB(255, 228, 106, 97),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          )
                        : SizedBox(
                            height: 20,
                          ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 21, vertical: 3),
                      height: 50,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTapDown: (details) =>
                            model.submitButtonTouched = true,
                        onTapUp: (details) {
                          FocusScope.of(context).unfocus();
                          model.submitButtonTouched = false;
                          model.sendForValidation();
                        },
                        onTapCancel: () => model.submitButtonTouched = false,
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          decoration: BoxDecoration(
                              color: model.submitButtonTouched
                                  ? AppColors.green
                                  : Colors.transparent,
                              border:
                                  Border.all(width: 3, color: AppColors.green),
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: model.submitButtonTouched
                                  ? Colors.white.withOpacity(0.8)
                                  : AppColors.green,
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
