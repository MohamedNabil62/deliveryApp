import 'package:delivery/core/app_colors.dart';
import 'package:delivery/core/app_sizes.dart';
import 'package:delivery/core/app_widgets.dart';
import 'package:delivery/core/extentions/add_seperator_extention.dart';
import 'package:delivery/core/network/local_storage.dart';
import 'package:delivery/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl; // alias 'intl'
import '../../../../core/app_routes.dart';
import '../../../../core/app_texts.dart';

class StaffHomeScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  StaffHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeBloc homeBloc = context.read<HomeBloc>();
    return BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeErrorState) {
            Fluttertoast.showToast(msg: state.message);
          }
          if (state is ShowStaffOrdersSuccessState) {
            homeBloc.startDateController.clear();
            homeBloc.endDateController.clear();
          }
        },
        builder: (context, state) => Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: SingleChildScrollView(
                child: SafeArea(
                    child: Padding(
                        padding: EdgeInsets.all(AppSizes.padding20.h.w),
                        child: Form(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'أهلا بك مجددا ${SharedPrefs.getString('name')}',
                                      style: TextStyle(
                                          fontFamily:AppTexts.fontFamily,
                                          fontSize: AppSizes.fontSize16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimaryColor
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          showAdaptiveDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialog.adaptive(
                                                    title: Text(
                                                      'هل تريد تسجيل الخروج؟',
                                                      style: TextStyle(
                                                        fontFamily:AppTexts.fontFamily,
                                                        fontSize: AppSizes.fontSize16.sp,
                                                        fontWeight: FontWeight.w600,
                                                        color: AppColors.subTitleColor,
                                                      ),
                                                      textAlign: TextAlign.end,
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            'الغاء',
                                                            style: TextStyle(
                                                              fontFamily:AppTexts.fontFamily,
                                                              fontSize: AppSizes.fontSize16.sp,
                                                              fontWeight: FontWeight.w600,
                                                              color: AppColors.subTitleColor,
                                                            ),
                                                          )),
                                                      TextButton(
                                                          onPressed: () async {
                                                            homeBloc.add(StaffLogOutEvent());
                                                            print(homeBloc.state.toString());
                                                            Navigator.popAndPushNamed(
                                                                    context,
                                                                    AppRoutes
                                                                        .login);

                                                          },
                                                          child: Text(
                                                              'تسجيل الخروج',
                                                              style: TextStyle(
                                                                fontFamily:AppTexts.fontFamily,
                                                                fontSize: AppSizes.fontSize16.sp,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.red,
                                                              ),)),
                                                    ],
                                                  ));
                                        },
                                        icon: const Icon(Icons.logout)),
                                  ],
                                ),
                                Text(
                                  'قم بتحديد التاريخ لعرض الطلبات',
                                  style: TextStyle(
                                      fontFamily:AppTexts.fontFamily,
                                      fontSize: AppSizes.fontSize16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimaryColor
                                  ),
                                ),
                                SizedBox(
                                  height: 90.h,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'من',
                                        style:TextStyle(
                                          fontFamily:AppTexts.fontFamily,
                                          fontSize: AppSizes.fontSize16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimaryColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 70.h,
                                        width: 120.w,
                                        child: GestureDetector(
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2020),
                                              lastDate: DateTime(2101),
                                            );

                                            if (pickedDate != null) {
                                              // Convert DateTime to the desired string format
                                              String formattedDate =
                                                  intl.DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                              // Update the date controller
                                              homeBloc.startDateController
                                                  .text = formattedDate;
                                              // Dispatch the DatePickedEvent with the DateTime object
                                              homeBloc.add(StartDatePickedEvent(
                                                  pickedDate));
                                            }
                                          },
                                          child: AbsorbPointer(
                                            child: BuildTextField(
                                              labelText: '',
                                              controller:
                                                  homeBloc.startDateController,
                                              hintText: 'yyyy-MM-dd',
                                              inputType: TextInputType.datetime,
                                              isSecure: false,
                                              isLabel: false,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'الى',
                                        style: TextStyle(
                                          fontFamily:AppTexts.fontFamily,
                                          fontSize: AppSizes.fontSize16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimaryColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 70.h,
                                        width: 120.w,
                                        child: GestureDetector(
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2020),
                                              lastDate: DateTime(2101),
                                            );

                                            if (pickedDate != null) {
                                              // Convert DateTime to the desired string format
                                              String formattedDate =
                                                  intl.DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                              // Update the date controller
                                              homeBloc.endDateController.text =
                                                  formattedDate;
                                              // Dispatch the DatePickedEvent with the DateTime object
                                              homeBloc.add(EndDatePickedEvent(
                                                  pickedDate));
                                            }
                                          },
                                          child: AbsorbPointer(
                                            child: BuildTextField(
                                              labelText: '',
                                              controller:
                                                  homeBloc.endDateController,
                                              hintText: 'yyyy-MM-dd',
                                              inputType: TextInputType.datetime,
                                              isSecure: false,
                                              isLabel: false,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                CustomAppButton(
                                  onPressed: () async {
                                    homeBloc.add(ShowStaffOrdersEvent(
                                        start_at:
                                            homeBloc.startDateController.text,
                                        end_at:
                                            homeBloc.endDateController.text));
                                  },
                                  isText: false,
                                  widget: state is HomeLoadingState
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : Text('عرض',
                                          style:TextStyle(
                                            fontFamily:AppTexts.fontFamily,
                                            fontSize: AppSizes.fontSize16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.backgroundColor,
                                          ),),
                                ),
                                state is ShowStaffOrdersSuccessState &&
                                        state.orderEntity.isNotEmpty
                                    ? Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  'الطلبات ${state.orderEntity.length} ',
                                                  style: TextStyle(
                                                    fontFamily:AppTexts.fontFamily,
                                                    fontSize: AppSizes.fontSize16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.subTitleColor,
                                                  ),),
                                              Text(
                                                'السعر الكلي : ${state.orderEntity.fold(0, (sum, order) => sum + order.price)}',
                                                style: TextStyle(
                                                  fontFamily:AppTexts.fontFamily,
                                                  fontSize: AppSizes.fontSize16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.subTitleColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 450.h,
                                            width: double.infinity,
                                            child: ListView.separated(
                                                shrinkWrap: true,
                                                primary: false,
                                                itemBuilder: (context, index) =>
                                                    Card(
                                                        color: Colors.white70,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  18.h.w),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text('التاريخ: ''${state.orderEntity[index].date}'),
                                                              Text('اسم الموظفين: '
                                                                  '${state.orderEntity[index].staffNames}'),
                                                              Text('الوصف: ''${state.orderEntity[index].descriptionTwo}'),

                                                              Text('اسم الفريق: ''${state.orderEntity[index].teamId}'),
                                                              Text('السعر: ' '${ state
                                                                  .orderEntity[
                                                              index]
                                                                  .price}'

                                                                      ),
                                                            ],
                                                          ),
                                                        )),
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                itemCount:
                                                    state.orderEntity.length),
                                          )
                                        ],
                                      )
                                    : Center(
                                        child: Text('لا يوجد طلبات لعرضها',
                                            style: TextStyle(
                                              fontFamily:AppTexts.fontFamily,
                                              fontSize: AppSizes.fontSize16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.subTitleColor,
                                            ),),
                                      )
                              ].addSeparator(
                                  separator: SizedBox(
                                height: AppSizes.padding20.h,
                              ))),
                        ))),
              ),
            )));
  }
}
