import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

class AppTerms extends StatefulWidget {
  const AppTerms({Key? key}) : super(key: key);

  @override
  _AppTermsState createState() => _AppTermsState();
}

class _AppTermsState extends State<AppTerms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 5,),
            "* By entering and participating in the v chat 's you agree to the following terms and conditions of participation. "
                .text,
            SizedBox(height: 5,),
            "* These terms and conditions are contractually binding upon you and you agree to each of them. "
                .text,
            SizedBox(height: 5,),
            "* You enter and participate in the Chat Room and gain access to the materials contained thereon at your own risk."
                .text,
            SizedBox(height: 5,),
            "* We do not monitor or screen communications on the Chat Room and we are not responsible for any material that any Chat Room participant posts and we do not assume the responsibility to do so. "
                .text,
            SizedBox(height: 5,),
            "* We do not make any representations or warranties as to the truth or accuracy of any statement made or materials posted on or through the Chat Room. You agree and acknowledge that you assume the risk of any actions you take in reliance upon the information that may be contained in the Chat Room. "
                .text,
            SizedBox(height: 5,),
            "* We do not endorse or lend any credence for any statements that are made by any participant in the Chat Room. "
                .text,
            SizedBox(height: 5,),
            "* Any opinions or views expressed by Chat Room participants are their own. We do not endorse or support or otherwise give any credence or reason for reliance on any such statements or opinions.  "
                .text,
            SizedBox(height: 5,),
            "* You are fully responsible for your own statements and materials that you post in the Chat Room and any consequences, whether or not foreseen, to any party who may rely upon these statements. "
                .text,
            SizedBox(height: 5,),
            "* From time to time, we, along with our authorised service providers, select Content in Third Party Platforms that we would like to use in V CHAT  Media.".text,
            SizedBox(height: 5,),
            "*  confirm that the Content is your original creation and not copied from third parties".text,
          ],
        ),
      ),
    );
  }
}
